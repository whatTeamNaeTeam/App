import 'package:flutter/material.dart';
import 'package:team_management_app/assets/color/colors.dart';

class DialogUI extends StatefulWidget {
  final Function(String bio) onPressed; // 입력된 값 전달을 위한 콜백 함수
  final String title;
  final String discription;

  const DialogUI({
    super.key,
    required this.onPressed,
    required this.title,
    required this.discription,
  });

  @override
  State<DialogUI> createState() => _DialogUIState();
}

class _DialogUIState extends State<DialogUI> {
  final TextEditingController _bioController =
      TextEditingController(); // 입력 필드 컨트롤러

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
            // 다이얼로그 타이틀
            // Text(
            //   widget.title,
            //   style: const TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.black87,
            //   ),
            // // ),
            // const SizedBox(height: 20),

            // 설명 텍스트
            Text(
              widget.discription,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 10),

            // 입력 필드
            TextField(
              controller: _bioController, // 텍스트 입력값 관리
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '각오 한마디!',
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),

            // 완료 및 취소 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.onPressed(_bioController.text); // 입력된 값 전달
                    Navigator.pop(context); // 다이얼로그 닫기
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(ButtonColors.indigo4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '완료',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // 다이얼로그 닫기
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(ButtonColors.red7),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '취소',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
