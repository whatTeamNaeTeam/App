import 'package:flutter/material.dart';
import 'package:team_management_app/assets/color/colors.dart';

class CancelButton extends StatefulWidget {
  const CancelButton({super.key});

  @override
  State<CancelButton> createState() => _CancelButtonState();
}

class _CancelButtonState extends State<CancelButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50), // 최소 크기 설정
        backgroundColor: Color(ButtonColors.red7color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
      ),
      onPressed: () {}, // 버튼 클릭 시 실행할 함수
      child: const Text(
        '취소',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
