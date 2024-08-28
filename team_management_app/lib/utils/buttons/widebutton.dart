import 'package:flutter/material.dart';

class WideButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final int buttonColor;
  final int textColor;
  final String title;

  const WideButton(
      {super.key,
      this.onPressed,
      required this.buttonColor,
      required this.textColor,
      required this.title});

  @override
  State<WideButton> createState() => _WideButtonState();
}

class _WideButtonState extends State<WideButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50), // 최소 크기 설정
        backgroundColor: Color(
          widget.buttonColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
      ),
      onPressed: widget.onPressed, // 버튼 클릭 시 실행할 함수
      child: Text(
        widget.title,
        style: TextStyle(
          color: Color(widget.textColor),
          fontSize: 16,
        ),
      ),
    );
  }
}
