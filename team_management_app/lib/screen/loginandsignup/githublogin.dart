import 'package:flutter/material.dart';
import 'package:team_management_app/api_service/api_service.dart';
import 'package:team_management_app/screen/loginandsignup/moresignup.dart';
import 'package:team_management_app/screen/team-inquiry/teaminquiry.dart';

class GithubLogin extends StatefulWidget {
  const GithubLogin({super.key});

  @override
  State<GithubLogin> createState() => GithubLoginState();
}

class GithubLoginState extends State<GithubLogin> {
  static bool? isLoggedIn = false; // 로그인 상태를 나타내는 bool

  String clientID = '';

  void signIn() async {
    // 'context'를 인자로 전달
    bool result = await ApiService.instance.signInWithGitHub(context);
    if (!result) {
      if (!mounted) return;
      // 추가 정보 입력란으로 넘어가기
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SignupPage(),
          ));
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(const SnackBar(content: Text('알수 없는 오류가 발생했습니다.')));
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
        child: isLoggedIn!
            ? const Teaminquiry() // 로그인 성공 시 메인페이지로 넘어가기 - 팀 조회 페이지
            : ElevatedButton(
                onPressed: signIn,
                child: const Text('Login with GitHub'),
              ),
      ),
    );
  }
}
