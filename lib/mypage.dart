import 'package:flutter/material.dart';
import 'package:swg/OrderHistory.dart';
import 'CustomerServicePage.dart'; // 고객센터 페이지 import
import 'ChangeName.dart';
import 'ChangeEmail.dart';
import 'Login.dart';
import 'search.dart';
import 'main.dart';
import 'OrderHistory.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final String userName = "홍길동"; // 사용자의 이름
  final int userPoints = 1200; // 사용자의 보유 포인트
  int _selectedIndex = 0; // 현재 선택된 bottom navigation bar 아이템의 인덱스

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.grey[200], // 배경색 변경
                    child: Icon(Icons.person, size: 40, color: Colors.grey), // 사람 이모티콘 색상 변경
                    radius: 30,
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '포인트: $userPoints',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(),
              ListTile(
                title: Text('계정', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('이름 변경'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangeUsernamePage()), // 변경된 부분
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.email),
                title: Text('이메일 변경'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangeEmailPage()), // 변경된 부분
                  );
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.list),
                title: Text('주문내역'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderHistoryPage()), // 변경된 부분
                  );                },
              ),
              Divider(),
              ListTile(
                title: Text('이용안내', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: Icon(Icons.support),
                title: Text('고객센터'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomerServicePage()),
                  );
                },
              ),
              Divider(),
              ListTile(
                title: Text('기타', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('로그아웃'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showLogoutDialog(context); // 로그아웃 확인 다이얼로그 표시
                },
              ),
              Divider(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false, // 선택된 아이템의 레이블 표시 여부
        showUnselectedLabels: false, // 선택되지 않은 아이템의 레이블 표시 여부
        currentIndex: _selectedIndex, // 현재 선택된 아이템의 인덱스
        onTap: (int index) {
          // 탭한 아이템에 따라 동작 처리
          setState(() {
            _selectedIndex = index;
            // 탭한 아이템에 따라 다른 동작을 수행하도록 구현할 수 있습니다.
            if (index == 0) {
              // Chat 아이콘을 탭했을 때의 동작
              // 이곳에 Chat 관련 동작을 추가하면 됩니다.
            } else if (index == 1) {
              // Search 아이콘을 탭했을 때의 동작
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            } else if (index == 2) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MainPage()),
              );
            } else if (index == 3) {
              // Camera 아이콘을 탭했을 때의 동작
              // 이곳에 Camera 관련 동작을 추가하면 됩니다.
            } else if (index == 4) {
              // Person 아이콘을 탭했을 때의 동작
              // 이곳에 Person 관련 동작을 추가하면 됩니다.
            }
          });
        },

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.black),
            label: '', // 레이블 비움
          ),
          BottomNavigationBarItem(
            icon: Row( // Row로 아이콘을 감싸고
              children: [
                SizedBox(width: 8), // 아이콘 사이 간격
                Icon(Icons.search, color: Colors.black),
              ],
            ),
            label: '', // 레이블 비움
          ),
          BottomNavigationBarItem(
            icon: Row(
              children: [
                SizedBox(width: 8),
                Icon(Icons.home, color: Colors.black),
              ],
            ),
            label: '', // 레이블 비움
          ),
          BottomNavigationBarItem(
            icon: Row(
              children: [
                SizedBox(width: 8),
                Icon(Icons.camera_alt, color: Colors.black),
              ],
            ),
            label: '', // 레이블 비움
          ),
          BottomNavigationBarItem(
            icon: Row(
              children: [
                SizedBox(width: 8),
                Icon(Icons.person, color: Colors.black),
              ],
            ),
            label: '', // 레이블 비움
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("로그아웃"),
          content: Text("정말 로그아웃 하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              child: Text("취소"),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
            TextButton(
              child: Text("로그아웃"),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LogInPage()), // 로그인 페이지로 이동
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class MyCustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return GlowingOverscrollIndicator(
      color: Colors.lightBlue, // 오버스크롤 글로우 색상 변경
      axisDirection: axisDirection,
      child: child,
    );
  }
}