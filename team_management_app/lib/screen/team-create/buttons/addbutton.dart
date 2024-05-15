import 'package:flutter/material.dart';
import 'package:team_management_app/assets/color/colors.dart';

class AddButton extends StatefulWidget {
  final VoidCallback? onPressed;
  const AddButton({
    super.key,
    this.onPressed,
  });

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  // TODO 팀 생성 post
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50), // 최소 크기 설정
        backgroundColor: Color(
          ButtonColors.indigo4color,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
      ),
      onPressed: widget.onPressed, // 버튼 클릭 시 실행할 함수
      child: const Text(
        '등록',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
