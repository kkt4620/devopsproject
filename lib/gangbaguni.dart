import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 장바구니',
      home: ShoppingCartScreen(),
    );
  }
}

class ShoppingCartScreen extends StatefulWidget {
  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  List<CartItem> items = [
    CartItem(
      imageUrl: 'https://picsum.photos/50', // 유효한 이미지 URL로 교체
      name: '우삼겹 덮밥 도시락+짬뽕국물',
      price: 11600,
      description: '사이즈 선택 : 큰 사이즈',
      quantity: 1,
    ),
    CartItem(
      imageUrl: 'https://picsum.photos/50', // 유효한 이미지 URL로 교체
      name: '치킨가라아게 덮밥+짬뽕국물',
      price: 10900,
      description: '맛 선택 : 순한맛',
      quantity: 2,
    ),
  ];

  void _incrementQuantity(int index) {
    setState(() {
      items[index].quantity++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (items[index].quantity > 1) {
        items[index].quantity--;
      }
    });
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = items.fold(0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('장바구니')), // 가운데 정렬
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return CartItemWidget(
                  item: items[index],
                  onIncrement: () => _incrementQuantity(index),
                  onDecrement: () => _decrementQuantity(index),
                  onRemove: () => _removeItem(index),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('메뉴 추가'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('$totalPrice원 • 결제하기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // primary 대신 backgroundColor 사용
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String imageUrl;
  final String name;
  final int price;
  final String description;
  int quantity;

  CartItem({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.description,
    required this.quantity,
  });
}

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const CartItemWidget({
    Key? key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0), // 둥근 모서리 설정
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            item.imageUrl,
                            width: 50,
                            height: 50,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 4.0),
                            Text('가격: ${item.price}원', style: TextStyle(fontSize: 12.0, color: Colors.grey)),
                            Text(item.description, style: TextStyle(fontSize: 12.0, color: Colors.grey)),
                            SizedBox(height: 8.0),
                            Text('${item.price * item.quantity}원', style: TextStyle(fontWeight: FontWeight.bold)), // 총 가격
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: onDecrement,
                      icon: Icon(Icons.remove),
                    ),
                    Text(item.quantity.toString()),
                    IconButton(
                      onPressed: onIncrement,
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: onRemove,
              icon: Icon(Icons.close, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}