import 'package:flutter/material.dart';
import 'package:team_management_app/api_service/api_service.dart';
import 'package:team_management_app/screen/team-create/teamcreate.dart';

class GithubLogin extends StatefulWidget {
  const GithubLogin({super.key});

  @override
  State<GithubLogin> createState() => GithubLoginState();
}

class GithubLoginState extends State<GithubLogin> {
  // static bool isLoggedIn = true; // ui 테스트시 true
  static bool isLoggedIn = false; // 실제 구현시 false

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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoggedIn
            ? const TeamCreate() // 로그인 성공 시 Testui 위젯 표시
            : ElevatedButton(
                onPressed: signIn,
                child: const Text('Login with GitHub'),
              ),
      ),
    );
  }
}
