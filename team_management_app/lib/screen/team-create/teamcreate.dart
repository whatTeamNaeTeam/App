import 'package:flutter/material.dart';
import 'package:team_management_app/screen/team-create/ImagePicker/imagepicker.dart';
import 'package:team_management_app/screen/team-create/buttons/addbutton.dart';
import 'package:team_management_app/screen/team-create/buttons/cancle.dart';
import 'package:team_management_app/screen/team-create/project-title/projecttitle.dart';
import 'package:team_management_app/screen/team-create/reference-link/referencelink.dart';
import 'fieldlist/fieldlist.dart';
import 'package:team_management_app/screen/team-create/markdown-editable-textinput/markdown_text_input.dart';

class TeamCreate extends StatefulWidget {
  const TeamCreate({super.key});
  @override
  State<TeamCreate> createState() => _TeamCreateState();
}

class _TeamCreateState extends State<TeamCreate> {
  TextEditingController description = TextEditingController(); // 프로젝트 설명*
  String _markdownText = "";

  void _handleTextChanged(String newText) {
    setState(() {
      _markdownText = newText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProjectTitle(),
              const SizedBox(height: 23),
              const FieldList(), // 모집 인원
              const SizedBox(height: 23),
              const ImagePicker(), // 대표 이미지
              const SizedBox(height: 23),
              MarkdownTextInput(
                _handleTextChanged,
                _markdownText,
                label: 'Enter markdown text',
              ), // 마크다운 필드
              const SizedBox(
                height: 23,
              ),
              const ReferenceLink(),
              const SizedBox(
                height: 23,
              ),
              // TODO 등록 버튼
              const AddButton(),
              const SizedBox(height: 10), // 버튼 사이의 간격
              const CancelButton(),
            ],
          ),
        ),
      ),
    );
  }
}
