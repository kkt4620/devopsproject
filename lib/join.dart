import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'firebase_options.dart';
import 'Login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '회원가입',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6DBE45), // ElevatedButton의 배경색
          ),
        ),
      ),
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isPasswordInvalid = false;

  void _signUp() async {
    // 각 입력란에 대한 값 확인
    String name = _nameController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;
    String phone = _phoneController.text;
    String email = _emailController.text;
    int point = 0;

    // 빈 입력란 확인
    if (name.isEmpty || password.isEmpty ||
        confirmPassword.isEmpty || phone.isEmpty || email.isEmpty) {
      // 빈 입력란이 있으면 오류 메시지 표시
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('회원가입 오류'),
              content: Text('빈 입력란이 있습니다. 모든 정보를 입력해주세요.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text('확인'),
                ),
              ],
            ),
      );
      return;
    }

    // 비밀번호 길이 확인
    if (password.length < 8) {
      setState(() {
        _isPasswordInvalid = true;
      });
      return;
    } else {
      setState(() {
        _isPasswordInvalid = false;
      });
    }

    // 비밀번호 확인
    if (password != confirmPassword) {
      // 비밀번호와 비밀번호 확인이 다르면 알림 출력
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('회원가입 오류'),
              content: Text('비밀번호가 일치하지 않습니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('확인'),
                ),
              ],
            ),
      );
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null){
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'phone': phone,
          'email': email,
          'password': password,
          'point': point,
          // 기타 추가 정보 저장
        });
        setState(() {
          _passwordController.clear();
        });
      }

      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('회원가입 성공'),
              content: Text('회원가입이 완료되었습니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LogInPage()),
                    );
                  },
                  child: Text('확인'),
                ),
              ],
            ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('회원가입 오류'),
              content: Text('회원가입 중 오류가 발생했습니다: ${e.toString()}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('확인'),
                ),
              ],
            ),
      );
    }

    // 여기서 회원가입 로직을 구현할 수 있습니다.
    // 실제로는 이 정보를 서버로 전송하여 회원가입 처리를 수행해야 합니다.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30.0),
            Center(
              child: Image.asset(
                'assets/logo.png', // 올리브영 로고 이미지
                height: 50.0,
              ),
            ),
            SizedBox(height: 30.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '사용자 이름',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: '이메일',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
                errorText: _isPasswordInvalid ? '비밀번호는 8글자 이상 입력하세요' : null,
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: '비밀번호 확인',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: '전화번호',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16.0),
            ElevatedButton
              (
              onPressed: _signUp,
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
