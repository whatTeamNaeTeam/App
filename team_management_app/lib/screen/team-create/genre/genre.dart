import 'package:flutter/material.dart';
import 'package:list_picker/list_picker.dart';

class Genre extends StatefulWidget {
  final String label;
  final TextEditingController genre;
  const Genre({super.key, required this.label, required this.genre});

  @override
  State<Genre> createState() => _GenreState();
}

class _GenreState extends State<Genre> {
  List<String> items = ['앱', '웹', '게임', 'AI'];
  TextEditingController? _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = widget.genre;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "프로젝트 분야 *",
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        ListPickerField(
          label: "장르 선택",
          items: items,
          controller: _textEditingController,
        ),
      ],
    );
  }
}
