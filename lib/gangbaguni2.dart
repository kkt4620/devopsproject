import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ship.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ShoppingCart(),
    );
  }
}

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  List<CartItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid; // 실제 UID로 교체하세요
      QuerySnapshot querySnapshot = await firestore.collection('users').doc(uid).collection('Cart').get();
      List<CartItem> items = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return CartItem(
          id: doc.id, // 문서 ID 저장
          name: data['productName'],
          price: data['price'],
          imageUrl: data['img'],
          quantity: data['quantity'], // 임시 값
        );
      }).toList();
      setState(() {
        cartItems = items;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int total = cartItems.fold(0, (previousValue, item) => previousValue + (item.price * item.quantity));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '장바구니',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    for (var item in cartItems) ...[
                      ShoppingCartItem(
                        item: item,
                        onQuantityChanged: (newQuantity) async {
                          await _updateQuantity(item, newQuantity);
                        },
                        onDelete: () {
                          _removeItem(item);
                        },
                      ),
                      Divider(color: Colors.grey),
                    ],
                    AddMenuButton(),
                  ],
                ),
              ),
            ),
          ),
          TotalAmount(total: total, cartItems: cartItems),
        ],
      ),
    );
  }

  Future<void> _updateQuantity(CartItem item, int newQuantity) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      // Firestore에서 문서 업데이트
      await firestore.collection('users').doc(uid).collection('Cart').doc(item.id).update({
        'quantity': newQuantity,
      });

      setState(() {
        item.quantity = newQuantity;
      });
    }
  }

  // Function to remove item from the cart
  void _removeItem(CartItem item) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      // Firestore에서 문서 삭제
      await firestore.collection('users').doc(uid).collection('Cart').doc(item.id).delete();

      setState(() {
        cartItems.remove(item);
      });
    }
  }
}

class TotalAmount extends StatelessWidget {
  final int total;
  final List<CartItem> cartItems;

  TotalAmount({required this.total, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          int finalTotal = total;
          List<String> itemNames = cartItems.map((item) => item.name).toList();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScreen(finalTotal: finalTotal, itemNames: itemNames),
            ),
          );
        },
        child: Text('$total원 • 결제하기'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 50),
        ),
      ),
    );
  }
}

class CartItem {
  final String id;
  final String name;
  final int price;
  int quantity;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });
}

class ShoppingCartItem extends StatelessWidget {
  final CartItem item;
  final Function(int) onQuantityChanged;
  final VoidCallback onDelete;

  ShoppingCartItem({required this.item, required this.onQuantityChanged, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text('기본 가격: ${item.price}원', style: TextStyle(fontSize: 14, color: Colors.grey)),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        item.quantity > 1
                            ? IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            onQuantityChanged(item.quantity - 1);
                          },
                        )
                            : IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: onDelete,
                        ),
                        Text('${item.quantity}'),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () {
                            onQuantityChanged(item.quantity + 1);
                          },
                        ),
                      ],
                    ),
                    Text('가격: ${item.price * item.quantity}원',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class AddMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: () {},
        child: Text('+ 메뉴 추가'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          textStyle: TextStyle(fontSize: 16),
          side: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}