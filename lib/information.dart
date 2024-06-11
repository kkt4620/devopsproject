import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'search.dart';
import 'main.dart';
import 'gangbaguni2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductPage(productName: "Your_Product_Name_Here"),
    );
  }
}

class ProductPage extends StatefulWidget {
  final String productName;

  ProductPage({required this.productName});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool isFavorited = false;
  late Future<DocumentSnapshot> productFuture;
  late String imageUrl = "";

  @override
  void initState() {
    super.initState();
    productFuture = getProduct(widget.productName);
  }

  Future<DocumentSnapshot> getProduct(String productName) async {
    // Product 컬렉션에서 productName과 일치하는 문서를 찾아옵니다.
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Product')
        .where('name', isEqualTo: widget.productName)
        .get();
    // 검색 결과가 있으면 첫 번째 문서를 반환합니다.
    return querySnapshot.docs.first;
  }

  Future<String> getImageUrl(String imagePath) async {
    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.home, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
              );
            },
          ),
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
      body: FutureBuilder<DocumentSnapshot>(
        future: productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
            return SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                    future: getImageUrl(data['img']), // 이미지 경로가 String으로 저장된 경우
                    builder: (context, imageSnapshot) {
                      if (imageSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (imageSnapshot.hasError) {
                        return Text('Error: ${imageSnapshot.error}');
                      } else {
                        imageUrl = imageSnapshot.data.toString();
                        return Image.network(imageUrl);
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '회사명: ${data['cn']}',
                                style: TextStyle(color: Colors.blue),
                              ),
                              SizedBox(height: 4),
                              Text(
                                widget.productName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${data['price']}원',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: Icon(
                                isFavorited
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorited ? Colors.red : Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  isFavorited = !isFavorited;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              addToCart(data);
                            },
                            child: Text('장바구니 담기'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text('바로구매'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '상품정보',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Table(
                          columnWidths: {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(2),
                          },
                          border: TableBorder.all(color: Colors.black12),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40), // 이미지 아래에 추가된 공간
                  FutureBuilder(
                    future: getImageUrl(data['opt']),
                    builder: (context, optImageSnapshot) {
                      if (optImageSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (optImageSnapshot.hasError) {
                        return Text('Error: ${optImageSnapshot.error}');
                      } else {
                        String optImageUrl = optImageSnapshot.data.toString();
                        return Image.network(optImageUrl);
                      }
                    },
                  ), // 추가된 이미지 // 추가된 이미지
                ],
              ),
            );
          }
        },
      ),
    );
  }
  void addToCart(Map<String, dynamic> productData) async {
    try {
      // 현재 로그인한 사용자 정보 가져오기
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // 현재 로그인한 사용자의 UID 가져오기
        String uid = user.uid;

        // Firestore에서 해당 UID를 가진 사용자의 문서 가져오기
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          // Firestore의 'Cart' 컬렉션에 사용자별로 서브컬렉션을 만들어 제품 정보를 저장합니다.
          CollectionReference userCartRef = FirebaseFirestore.instance.collection('users').doc(uid).collection('Cart');

          // 같은 제품명이 이미 있는지 확인
          QuerySnapshot querySnapshot = await userCartRef.where('productName', isEqualTo: productData['name']).get();

          if (querySnapshot.docs.isNotEmpty) {
            // 동일한 제품명이 이미 있을 경우
            DocumentSnapshot existingDoc = querySnapshot.docs.first;
            Map<String, dynamic> existingData = existingDoc.data() as Map<String, dynamic>;
            int currentQuantity = existingData['quantity'] ?? 1;

            // quantity를 1 증가시켜 업데이트
            await existingDoc.reference.update({
              'quantity': currentQuantity + 1,
            });

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('장바구니에 상품 수량이 업데이트되었습니다.'),
            ));
          } else {
            // 동일한 제품명이 없을 경우 새 문서를 생성
            await userCartRef.add({
              'productName': productData['name'], // 제품명
              'price': productData['price'], // 가격
              'img': productData['img'], // 이미지 경로
              'quantity': 1, // 초기 수량
            });

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('장바구니에 상품이 추가되었습니다.'),
            ));
          }
        }
      } else {
        // 사용자가 로그인하지 않은 경우에 대한 처리
        // 예: 사용자에게 로그인을 유도하는 메시지 표시 등
      }
    } catch (e) {
      // 오류가 발생했을 경우 사용자에게 오류 메시지를 표시합니다.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('장바구니에 상품을 추가하는 중 오류가 발생했습니다.'),
      ));
    }
  }
}
