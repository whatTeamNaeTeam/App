import 'package:flutter/material.dart';
import 'package:team_management_app/assets/color/colors.dart';

// 성공적으로 완료되었다는 메시지를 표시해주는 알림창
class CustomAlertDialog extends StatefulWidget {
  final String title;
  final String discription;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.discription,
  });

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 12,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // 설명 텍스트
            Text(
              widget.discription,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // 다이얼로그 닫기
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(ButtonColors.red7),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '확인',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
