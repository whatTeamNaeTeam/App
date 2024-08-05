import 'package:flutter/material.dart';

class NeedDevelop {
  static void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text(
            '서비스 준비중',
            style: TextStyle(fontSize: 24),
          ),
          content: Text(
            '서비스 준비중입니다! ㅜㅜ 빠른 시일 내에 이용해보실 수 있습니다!',
            style: TextStyle(fontSize: 14),
          ),
        );
      },
    );
  }
}
