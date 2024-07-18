import 'package:flutter/material.dart';

class NeedDevelop {
  static void showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('개발 필요'),
          content: Text('개발이 필요합니다.'),
        );
      },
    );
  }
}
