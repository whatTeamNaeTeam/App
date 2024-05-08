import 'package:flutter/material.dart';
import 'package:team_management_app/screen/githublogin.dart';
import 'package:team_management_app/screen/moresignup.dart';
import 'package:team_management_app/screen/team-create/teamcreate.dart';

class AllScreen extends StatefulWidget {
  const AllScreen({super.key});

  @override
  State<AllScreen> createState() => _AllScreenState();
}

class _AllScreenState extends State<AllScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const GithubLogin())),
              child: const Text("깃허브 로그인"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SignupPage())),
              child: const Text("추가 정보 입력"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const TeamCreate())),
              child: const Text("팀 생성 페이지"),
            ),
          ],
        ),
      ),
    );
  }
}
