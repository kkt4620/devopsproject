import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PaymentScreen(
          finalTotal: 0,
          itemNames: []
      ),
    );
  }
}

class CartItem {
  final String name;
  final double price;
  CartItem({required this.name, required this.price});
}

class PaymentScreen extends StatefulWidget {
  final List<String> itemNames; // gangbaguni.dart에서 받은 아이템 이름 목록
  final int finalTotal; // 최종 가격을 받을 준비를 합니다.

  PaymentScreen({required this.itemNames, required this.finalTotal});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  double points = 302;
  bool usePoints = false;
  String paymentMethod = "bank_transfer";
  String selectedBank = "KB국민은행";
  bool agreeToTerms = false;
  final TextEditingController depositorNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double totalAmount = widget.finalTotal.toDouble(); // 이전의 cartItems를 사용하지 않으므로 finalTotal을 이용하여 총 가격을 계산합니다.
    double pointsUsed = usePoints ? points : 0;
    double finalAmount = totalAmount - pointsUsed;

    // Generate order number based on current date
    String orderNumber = DateFormat('yyyyMMdd').format(DateTime.now()) + '001';

    // Format the amounts with comma separators and no decimal points
    final formattedTotalAmount = NumberFormat.currency(locale: 'ko_KR', symbol: '', decimalDigits: 0).format(totalAmount);
    final formattedFinalAmount = NumberFormat.currency(locale: 'ko_KR', symbol: '', decimalDigits: 0).format(finalAmount);
    final formattedPoints = NumberFormat.currency(locale: 'ko_KR', symbol: '', decimalDigits: 0).format(points);
    final formattedPointsUsed = NumberFormat.currency(locale: 'ko_KR', symbol: '', decimalDigits: 0).format(pointsUsed);

    return Scaffold(
      appBar: AppBar(
        title: Text('주문/결제'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("주문상품", style: TextStyle(fontSize: 18)),
            ...widget.itemNames.map((itemName) => Text(itemName, style: TextStyle(color: Colors.grey))), // gangbaguni.dart에서 받은 아이템 이름 목록을 사용하여 출력
            SizedBox(height: 20),
            Text("포인트", style: TextStyle(fontSize: 18)),
            Row(
              children: [
                Checkbox(
                  value: usePoints,
                  onChanged: (bool? value) {
                    setState(() {
                      usePoints = value!;
                    });
                  },
                ),
                Text("사용 가능한 포인트: ${formattedPoints} P", style: TextStyle(color: Colors.grey)),
              ],
            ),
            Text(
              "결제 시 0.5% 포인트가 적립됩니다.",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text("결제방식", style: TextStyle(fontSize: 18)),
            ListTile(
              title: Text("계좌이체"),
              leading: Radio(
                value: "bank_transfer",
                groupValue: paymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    paymentMethod = value!;
                  });
                },
              ),
            ),
            if (paymentMethod == "bank_transfer") ...[
              TextField(
                controller: depositorNameController,
                decoration: InputDecoration(labelText: "입금자명"),
              ),
              SizedBox(height: 20),
              Text("은행 선택", style: TextStyle(fontSize: 18)),
              Wrap(
                spacing: 10,
                children: [
                  ChoiceChip(
                    label: Text("KB국민은행"),
                    selected: selectedBank == "KB국민은행",
                    onSelected: (bool selected) {
                      setState(() {
                        selectedBank = "KB국민은행";
                      });
                    },
                  ),
                  ChoiceChip(
                    label: Text("우리은행"),
                    selected: selectedBank == "우리은행",
                    onSelected: (bool selected) {
                      setState(() {
                        selectedBank = "우리은행";
                      });
                    },
                  ),
                  ChoiceChip(
                    label: Text("농협은행"),
                    selected: selectedBank == "농협은행",
                    onSelected: (bool selected) {
                      setState(() {
                        selectedBank = "농협은행";
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
            Spacer(),
            Row(
              children: [
                Checkbox(
                  value: agreeToTerms,
                  onChanged: (bool? value) {
                    setState(() {
                      agreeToTerms = value!;
                    });
                  },
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0), // Padding 추가
                    color: Colors.grey[200], // 배경색 추가
                    child: Text(
                      "주문 상품정보 및 결제대행 서비스 이용약관에 동의합니다.",
                      style: TextStyle(color: Colors.black, fontSize: 16), // 텍스트 크기 조정
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "결제금액: ${formattedFinalAmount} 원",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
                onPressed: agreeToTerms
                    ? () {
                  double pointsEarned = (totalAmount * 0.005).floorToDouble();
                  DateTime now = DateTime.now();
                  DateTime depositDeadline = now.add(Duration(days: 7));
                  String formattedDeadline = DateFormat('yy년 MM월 dd일').format(depositDeadline);

                  setState(() {
                    points += pointsEarned - (usePoints ? points : 0);
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentCompleteScreen(
                        orderNumber: orderNumber,
                        formattedFinalAmount: formattedFinalAmount,
                        selectedBank: selectedBank,
                        depositorName: depositorNameController.text,
                        depositDeadline: formattedDeadline,
                        totalAmount: formattedTotalAmount,
                        pointsUsed: formattedPointsUsed,
                      ),
                    ),
                  );
                }
                    : null,
                child: Text("${formattedFinalAmount}원 결제하기"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentCompleteScreen extends StatelessWidget {
  final String orderNumber;
  final String formattedFinalAmount;
  final String selectedBank;
  final String depositorName;
  final String depositDeadline;
  final String totalAmount;
  final String pointsUsed;

  PaymentCompleteScreen({
    required this.orderNumber,
    required this.formattedFinalAmount,
    required this.selectedBank,
    required this.depositorName,
    required this.depositDeadline,
    required this.totalAmount,
    required this.pointsUsed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('주문완료'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                '결제 완료',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Text('주문 정보', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            _buildPaymentInfoRow('주문번호', orderNumber),
            _buildPaymentInfoRow('결제방법', '계좌 이체'),
            _buildPaymentInfoRow('입금 계좌', '$selectedBank 945802-00-824374 $depositorName'),
            _buildPaymentInfoRow('입금기한', '$depositDeadline (D-7)'),
            _buildPaymentInfoRow('상품금액', totalAmount),
            _buildPaymentInfoRow('적립금사용', pointsUsed),
            SizedBox(height: 20),
            Text('총 결제금액', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('$formattedFinalAmount 원', style: TextStyle(fontSize: 18, color: Colors.blue)),
            Spacer(),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
                },
                child: Text('홈으로 이동'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfoRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
