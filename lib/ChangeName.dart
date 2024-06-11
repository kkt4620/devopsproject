import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeUsernamePage extends StatefulWidget {
  @override
  _ChangeUsernamePageState createState() => _ChangeUsernamePageState();
}

class _ChangeUsernamePageState extends State<ChangeUsernamePage> {
  TextEditingController _usernameController = TextEditingController();
  String _currentUsername = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUsername = prefs.getString('username') ?? '';
    });
  }

  Future<void> _saveUsername(String newUsername) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', newUsername);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '사용자 이름 변경',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20), // 추가된 여백
            Text(
              '현재 사용자 이름: $_currentUsername',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              '새로운 사용자 이름을 입력하세요:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: '새로운 이름',
                  contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _changeUsername(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white, // 버튼 색상 변경
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // 버튼 모양 변경
                  ),
                ),
                child: Text('확인'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeUsername(BuildContext context) async {
    String newUsername = _usernameController.text.trim();
    if (newUsername.isNotEmpty) {
      await _saveUsername(newUsername);

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).update({'name': newUsername});
      }

      setState(() {
        _currentUsername = newUsername;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('사용자 이름이 변경되었습니다.'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('새로운 사용자 이름을 입력하세요.'),
        ),
      );
    }
  }
}
