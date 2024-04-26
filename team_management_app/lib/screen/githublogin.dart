import 'package:flutter/material.dart';
import 'package:team_management_app/api_service/api_service.dart';

import 'testui.dart'; // Testui 클래스가 정의된 파일

class GithubLogin extends StatefulWidget {
  const GithubLogin({super.key});

  @override
  State<GithubLogin> createState() => GithubLoginState();
}

class GithubLoginState extends State<GithubLogin> {
  static bool isLoggedIn = false;
  String clientID = '';

  void signIn() async {
    // 'context'를 인자로 전달
    bool result = await ApiService.instance.signInWithGitHub(context);
    if (!result) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('ClientID 오류 또는 서버 오류')));
    } else {
      if (!mounted) return;
      setState(() {
        isLoggedIn = true; // 로그인 성공 시 isLoggedIn을 true로 설정
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const UserListWidget())); // Testui 페이지로 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoggedIn
            ? const UserListWidget() // 로그인 성공 시 Testui 위젯 표시
            : ElevatedButton(
                onPressed: signIn,
                child: const Text('Login with GitHub'),
              ),
      ),
    );
  }
}
