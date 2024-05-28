import 'package:flutter/material.dart';

class EntireAppbar extends StatelessWidget implements PreferredSizeWidget {
  const EntireAppbar({super.key});

  void appbarmainpage() {
    // AppBar 메인 페이지 로직
    print("AppBar icon tapped");
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white, // AppBar 배경 투명 설정
      elevation: 0, // AppBar 그림자 제거
      automaticallyImplyLeading: false,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.favorite), // 아이콘 설정
          onPressed: appbarmainpage, // 아이콘 눌렀을 때 실행할 함수
        ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // AppBar의 기본 높이 설정
}
