import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({Key? key, required this.camera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Camera Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CameraScreen(camera: camera),
    );
  }
}

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      final image = await _controller.takePicture();
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = path.join(directory.path, '${DateTime.now()}.png');
      await image.saveTo(imagePath);

      final className = await _uploadFile(File(imagePath));
      await Future.delayed(Duration(seconds: 3));
      final fetchImage = await _fetchImage();
      Uint8List imageBytes = Base64Decoder().convert(fetchImage);

      if (className != 'Unknown') {
        final DocumentReference documentReference = FirebaseFirestore.instance.collection('Product').doc(className);
        final documentSnapshot = await documentReference.get();
        final name = documentSnapshot['name'] ?? '';

        await _showProductInfo(name, imageBytes);
      } else {
        _showAlert1(context, className, imageBytes, false);
      }
    } catch (e) {
      print(e);
      _showAlert1(context, 'Error: $e', Uint8List(0), false);
    }
  }

  Future<String> _fetchImage() async {
    final response = await http.get(Uri.parse('http://220.68.27.150:6455/get_image'));
    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      return decodedResponse['image'];
    } else {
      throw Exception('Failed to fetch image');
    }
  }

  Future<String> _uploadFile(File file) async {
    final uri = Uri.parse('http://220.68.27.150:6455/upload');

    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('picture', file.path));

    var response = await request.send();
    var responseBody = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      final responseData = json.decode(responseBody.body);
      return responseData['class_name'];
    } else {
      print('File upload failed');
      return 'Unknown';
    }
  }

  Future<void> _showProductInfo(String className, Uint8List imageBytes) async {
    final DocumentReference documentReference = FirebaseFirestore.instance.collection('Product').doc(className);
    final documentSnapshot = await documentReference.get();

    if (documentSnapshot.exists) {
      final name = documentSnapshot['name'] ?? '';
      _showAlert(context, name, imageBytes, true);
    } else {
      _showAlert(context, className, imageBytes, false);
    }
  }

  void _showAlert(BuildContext context, String message, Uint8List img, bool hasProduct) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(message)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              img.isNotEmpty
                  ? Image.memory(img, height: 150, width: 150)
                  : Container(),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('재촬영'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('장바구니 추가'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  void _showAlert1(BuildContext context, String message, Uint8List img, bool hasProduct) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(message)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              img.isNotEmpty
                  ? Image.memory(img, height: 150, width: 150)
                  : Container(),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('재촬영'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  List<Widget> _buildProductActions(BuildContext context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('재촬영'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('장바구니 추가'),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildRetryAction(BuildContext context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Center(child: Text('재촬영')),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}