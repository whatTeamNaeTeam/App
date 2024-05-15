import 'package:flutter/material.dart';
import 'package:team_management_app/screen/loginandsignup/githublogin.dart';
import 'package:team_management_app/screen/management/teammanagement.dart';
import 'package:team_management_app/screen/management/unapproveteams.dart';
import 'package:team_management_app/screen/loginandsignup/moresignup.dart';
import 'package:team_management_app/screen/team-create/teamcreate.dart';
import 'package:team_management_app/screen/team-inquiry/teaminquiry.dart';
import 'package:team_management_app/screen/management/unapprovedusers.dart';

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
            ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Teaminquiry())),
              child: const Text("팀 조회 페이지"),
            ),
            const Divider(),
            const Text(
              "관리자",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UnApproveTeams())),
              child: const Text("미승인 팀 조회 페이지"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserListWidget())),
              child: const Text("미승인 회원 조회 페이지"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TeamManagement())),
              child: const Text("팀 관리 페이지"),
            ),
          ],
        ),
      ),
    );
  }
}
