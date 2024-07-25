import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_management_app/provider/userdata_provider.dart';
import 'package:team_management_app/screen/loginandsignup/githublogin.dart';
import 'package:team_management_app/utils/need_develop.dart';

class EntireAppbar extends ConsumerWidget implements PreferredSizeWidget {
  const EntireAppbar({super.key});

  void appbarmainpage(WidgetRef ref) {
    // AppBar 메인 페이지 로직
    final user = ref.read(userProvider)?['user'];
    log('provider 로그: $user');
    NeedDevelop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)?['user'];
    final String? imageUrl = user?['image_url']; // 로그인시 받아오는 ImageUrl을 설정하기

    return AppBar(
      backgroundColor: Colors.white, // AppBar 배경 투명 설정
      elevation: 0, // AppBar 그림자 제거
      automaticallyImplyLeading: false,
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
          if (imageUrl != null)
            Padding(
              padding: const EdgeInsets.only(right: 0), // 오른쪽 여백 추가
              child: GestureDetector(
                onTap: () {
                  log('Profile image tapped');
                },
                child: ClipOval(
                  child: Image.network(
                    imageUrl,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // AppBar의 기본 높이 설정
}
