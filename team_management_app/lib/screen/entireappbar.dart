import 'package:flutter/material.dart';
<<<<<<< Updated upstream
=======
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_management_app/screen/loginandsignup/githublogin.dart';
import 'package:team_management_app/utils/need_develop.dart';
>>>>>>> Stashed changes

class EntireAppbar extends StatelessWidget implements PreferredSizeWidget {
  const EntireAppbar({super.key});

<<<<<<< Updated upstream
<<<<<<< Updated upstream
  void appbarmainpage() {
    // AppBar 메인 페이지 로직
    log("AppBar icon tapped");
  }

=======
>>>>>>> Stashed changes
  @override
  Widget build(BuildContext context) {
=======
  @override
  Widget build(BuildContext context, WidgetRef ref) {
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
    return AppBar(
      backgroundColor: Colors.white, // AppBar 배경 투명 설정
      elevation: 0, // AppBar 그림자 제거
      automaticallyImplyLeading: false,
<<<<<<< Updated upstream
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.favorite), // 아이콘 설정
          onPressed: appbarmainpage, // 아이콘 눌렀을 때 실행할 함수
        ),
      ],
=======
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 0), // 왼쪽 여백 추가
            child: IconButton(
              icon: Image.asset(
                'assets/icons/wap_icon.png', // 커스텀 아이콘 경로
                width: 45,
                height: 45,
                color: Colors.black, // 아이콘 색상 (필요에 따라 설정)
              ),
              onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const GithubLogin())), // 아이콘 눌렀을 때 실행할 함수
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 0), // 오른쪽 여백 추가
            child: GestureDetector(
              onTap: () => NeedDevelop.showAlert(context),
              child: const Icon(
                Icons.notifications,
                size: 30,
              ),
            ),
          ),
        ],
      ),
>>>>>>> Stashed changes
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // AppBar의 기본 높이 설정
}
