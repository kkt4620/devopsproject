import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // url_launcher 패키지 추가

class CustomerServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '고객센터',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.person, size: 50),
              title: Text(
                '드리미',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '드리미 고객센터',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.phone, size: 50),
              title: Text(
                '010-8430-9947',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                _call(context, '01084309947');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.email, size: 50),
              title: Text(
                'mncat0903@gmail.com',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                _sendEmail(context, 'mncat0903@gmail.com');
              },
            ),
            Divider(),
            SizedBox(height: 20),
            Text(
              '자주 묻는 질문',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text(
                '1. 주문 취소는 어떻게 하나요?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '주문 취소는 주문 후 24시간 이내에 가능합니다. 마이페이지에서 주문을 취소할 수 있습니다.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ListTile(
              title: Text(
                '2. 포인트 적립은 어떻게 이루어지나요?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '상품 결제시 0.5% 포인트가 적립됩니다.',
                style: TextStyle(fontSize: 16),
              ),
            ),
            ListTile(
              title: Text(
                '3. 반품 및 교환은 어떻게 진행되나요?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '상품의 불량 또는 구매 변심시 7일 이내에 반품이 가능합니다. 교환은 상품 재고 상황에 따라 진행됩니다.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _call(BuildContext context, String phoneNumber) async {
    String telScheme = 'tel:$phoneNumber';
    Uri uri = Uri.parse(telScheme); // 문자열을 Uri로 변환
    if (await canLaunchUrl(uri)) { // 수정된 부분
      await launch(uri.toString());
    } else {
      // 전화 걸기 기능을 지원하지 않는 경우
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('전화 걸기를 지원하지 않습니다.'),
        ),
      );
    }
  }

  void _sendEmail(BuildContext context, String email) async {
    String emailScheme = 'mailto:$email';
    Uri uri = Uri.parse(emailScheme); // 문자열을 Uri로 변환
    if (await canLaunchUrl(uri)) { // 수정된 부분
      await launch(uri.toString());
    } else {
      // 이메일 보내기 기능을 지원하지 않는 경우
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('이메일 보내기를 지원하지 않습니다.'),
        ),
      );
    }
  }
}