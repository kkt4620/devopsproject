import 'package:flutter/material.dart';

class OrderHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '주문 내역',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return _buildOrderItem(context, orders[index]);
        },
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, Order order) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(
          '주문번호: ${order.orderNumber}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Text('주문일자: ${order.orderDate}'),
            Text('가격: ${order.price} 원'),
          ],
        ),
        onTap: () {
          // 주문 상세 페이지로 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailPage(order: order),
            ),
          );
        },
      ),
    );
  }
}

class Order {
  final String orderNumber;
  final String productName;
  final int price;
  final String orderDate;

  Order({
    required this.orderNumber,
    required this.productName,
    required this.price,
    required this.orderDate,
  });
}

final List<Order> orders = [
  Order(
    orderNumber: '20240610001',
    productName: 'Smartphone',
    price: 50000, // 50,000 원
    orderDate: '2024-06-10',
  ),
  Order(
    orderNumber: '20240610002',
    productName: 'Laptop',
    price: 120000, // 120,000 원
    orderDate: '2024-06-09',
  ),
  // Add more orders here...
];

class OrderDetailPage extends StatelessWidget {
  final Order order;

  const OrderDetailPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주문 상세 정보', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '주문 정보',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildPaymentInfoRow('주문번호', order.orderNumber),
            _buildPaymentInfoRow('결제방법', '계좌 이체'),
            _buildPaymentInfoRow('입금 계좌', '$selectedBank 945802-00-824374 $depositorName'),
            _buildPaymentInfoRow('입금기한', '$depositDeadline (D-7)'),
            _buildPaymentInfoRow('상품금액', '${_formatPrice(order.price)}'),
            _buildPaymentInfoRow('적립금사용', pointsUsed),
            SizedBox(height: 20),
            Text('총 결제금액', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('${_formatPrice(order.price)} 원', style: TextStyle(fontSize: 18, color: Colors.blue)),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(value),
      ],
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }
}

// Dummy data for payment information
final String selectedBank = '신한은행';
final String depositorName = '홍길동';
final String depositDeadline = '2024-06-17';
final String pointsUsed = '0';
