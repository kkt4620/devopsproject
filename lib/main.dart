import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'search.dart';
import 'gesipan.dart';
import 'newitem.dart';
import 'hititem.dart';
import 'saleitem.dart';
import 'mypage.dart';
import 'gangbaguni2.dart';
import 'dart:async';
import 'camera.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  int _selectedIndex = 2;
  late CameraDescription camera;

  final List<String> _banners = [
    'assets/banner1.png',
    'assets/banner2.png',
  ];

  List<String> _notices = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });

    _fetchNotices();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    camera = cameras.first;
  }

  Future<void> _fetchNotices() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('notice').get();
    setState(() {
      String counter = '*';
      _notices = querySnapshot.docs.expand((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return data.values.map((value) => '$counter. $value');
      }).toList();
    });
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FeedbackPage()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraScreen(camera: camera)),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '드리미 편의점',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShoppingCart()),
              );
            },
          ),
        ],
      ),
      body: Column(
          children: [
      Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: '검색',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            borderSide: BorderSide(color: Color(0xFF0D5AFF), width: 2.0),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchScreen()),
          );
        },
      ),
    ),
    SizedBox(height: 8),
    Container(
    width: double.infinity,
    height: 200,
    margin: EdgeInsets.only(top: 8.0),
    child: PageView.builder(
    controller: _pageController,
    itemCount: _banners.length,
    itemBuilder: (context, index) {
    return Image.asset(
    _banners[index],
    fit: BoxFit.cover,
    );
    },
    ),
    ),
    SizedBox(height: 8),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
    Column(
    children: [
    IconButton(
    icon: Icon(Icons.new_releases, size: 40),
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => newProductBoard()),
    );
    },
    ),
    Text('신상품', style: TextStyle(fontSize: 12)),
    ],
    ),
    Column(
    children: [
    IconButton(
    icon: Icon(Icons.trending_up, size: 40),
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => HitProductBoard()),
    );
    },
    ),
    Text('인기상품', style: TextStyle(fontSize: 12)),
    ],
    ),
    Column(
    children: [
    IconButton(
    icon: Icon(Icons.favorite_border, size: 40),
    onPressed: () {},
    ),
    Text('관심상품', style: TextStyle(fontSize: 12)),
    ],
    ),
    Column(
    children: [
    IconButton(
    icon: Icon(Icons.local_offer, size: 40),
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => SaleProductBoard()),
    );
    },
    ),
    Text('세일상품', style: TextStyle(fontSize: 12)),
    ],
    ),
    ],
    ),
    SizedBox(height: 12),
    Expanded(
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Container(
    decoration: BoxDecoration(
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Padding(
    padding: const EdgeInsets.all(12.0),
    child: Row(
    children: [
    Icon(Icons.announcement),
    SizedBox(width: 8),
    Text(
    '공지사항',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
    ),
    Expanded(
    child: ListView.builder(
    padding: EdgeInsets.zero,
    itemCount: _notices.length,
    itemBuilder: (context, index) {
    return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12.0),
    child: Text(
      _notices[index],
      style: TextStyle(
        fontSize: 16, // 텍스트 크기 조정
      ),
    ),
    );
    },
    ),
    ),
    ],
    ),
    ),
    ),
    ),
          ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Row(
              children: [
                SizedBox(width: 8),
                Icon(Icons.search, color: Colors.black),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Row(
              children: [
                SizedBox(width: 8),
                Icon(Icons.home, color: Colors.black),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Row(
              children: [
                SizedBox(width: 8),
                Icon(Icons.camera_alt, color: Colors.black),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Row(
              children: [
                SizedBox(width: 8),
                Icon(Icons.person, color: Colors.black),
              ],
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
