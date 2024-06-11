import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangeEmailPage extends StatefulWidget {
  @override
  _ChangeEmailPageState createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  TextEditingController _emailController = TextEditingController();
  String _currentEmail = '';

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentEmail = prefs.getString('email') ?? '';
    });
  }

  Future<void> _saveEmail(String newEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', newEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '이메일 변경',
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
              '현재 이메일: $_currentEmail',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              '새로운 이메일을 입력하세요:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: '새로운 이메일',
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
                  _changeEmail(context);
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

  void _changeEmail(BuildContext context) async {
    String newEmail = _emailController.text.trim();
    if (newEmail.isNotEmpty) {
      await _saveEmail(newEmail);

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await user.updateEmail(newEmail);
          String uid = user.uid;
          await FirebaseFirestore.instance.collection('users').doc(uid).update(
              {'email': newEmail});

          setState(() {
            _currentEmail = newEmail;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('이메일이 변경되었습니다.'),
            ),
          );
        } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('이메일 변경에 실패했습니다: ${e.message}'),
            ),
          );
        }
      }
    }
  }
}