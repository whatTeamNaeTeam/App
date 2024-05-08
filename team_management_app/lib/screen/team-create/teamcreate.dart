import 'dart:io';
import 'package:flutter/material.dart';
import 'package:team_management_app/screen/team-create/ImagePicker/imagepicker.dart';
import 'package:team_management_app/screen/team-create/buttons/addbutton.dart';
import 'package:team_management_app/screen/team-create/buttons/cancle.dart';
import 'package:team_management_app/screen/team-create/genre/genre.dart';
import 'package:team_management_app/screen/team-create/project-title/projecttitle.dart';
import 'package:team_management_app/screen/team-create/reference-link/referencelink.dart';
import 'fieldlist/fieldlist.dart';
import 'package:team_management_app/screen/team-create/markdown-editable-textinput/markdown_text_input.dart';
import 'package:team_management_app/api_service/api_service.dart';

class TeamCreate extends StatefulWidget {
  const TeamCreate({super.key});
  @override
  State<TeamCreate> createState() => _TeamCreateState();
}

class _TeamCreateState extends State<TeamCreate> {
  // 프로젝트 제목 컨트롤러 선언
  final TextEditingController _projectTitleController = TextEditingController();
  // 프로젝트 분야
  final TextEditingController _genre = TextEditingController();
  // 전공분야 고르기 초기 배열
  final List<TextEditingController> _fields = [];
  // markdownText 초기 값
  String _markdownText = "";
  // 이미지 파일 초기 값
  File? _file;
  // 참조 링크 초기 배열
  final List<TextEditingController> _referencelinks = [];

  // add 버튼 전송용 코드
  String? projectTitle;
  String? projectGenre;
  String? projectURL;
  List<String>? projectFields;
  List<int>? memberCountList;

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
              // 프로젝트 제목
              ProjectTitle(
                  initialprojectTitleController: _projectTitleController),
              const SizedBox(height: 23),
              // 프로젝트 분야
              Genre(
                label: "프로젝트 분야 선택",
                genre: _genre,
              ),
              const SizedBox(
                height: 23,
              ),
              // 모집 분야
              FieldList(
                initialcontrollers: _fields,
              ), // 모집 인원
              const SizedBox(height: 23),
              // 이미지 가져오기
              ImagePicker(
                initialimage: _file,
                onImageUpdated: (updateFile) {
                  setState(() {
                    _file = updateFile;
                  });
                },
              ), // 대표 이미지
              const SizedBox(height: 23),
              // 마크다운 필드
              MarkdownTextInput(
                _handleTextChanged,
                _markdownText,
                label: 'Enter markdown text',
              ),
              const SizedBox(
                height: 23,
              ),
              // 참조 링크
              ReferenceLink(
                initialreferencelinks: _referencelinks,
              ),
              const SizedBox(
                height: 23,
              ),
              // 등록 버튼
              AddButton(
                onPressed: registerTeam,
              ),
              const SizedBox(height: 10), // 버튼 사이의 간격
              // 취소 버튼
              const CancelButton(),
            ],
          ),
        ),
      ),
    );
  }

  void registerTeam() {
    updatefunction();
    ApiService.instance.createNewTeam(projectTitle, projectGenre, projectFields,
        memberCountList, _markdownText, _file, projectURL);
    // print("프로젝트 제목: $projectTitle");

    // print("프로젝트 장르: $projectGenre");

    // print("전공 분야: $projectFields");

    // print("멤버 수: $memberCountList");

    // print("마크 다운: $_markdownText");

    // print("파일: $_file");

    // print("참조 링크: $projectURL");
  }

  // 팀 생성 값 update
  void updatefunction() {
    setState(() {
      projectTitle = _projectTitleController.text; // 프로젝트 제목
      projectGenre = _genre.text; // 앱 장르
      projectURL = _referencelinks
          .map((controller) => controller.text)
          .join(','); // url String 타입으로
      projectFields =
          _fields.map((controller) => controller.text).toList(); // 분야를 리스트로

      Map<String, int> memberCounts = {}; // 분야별 인원 수 계산
      for (String field in projectFields!) {
        memberCounts[field] =
            (memberCounts[field] ?? 0) + 1; // null을 확인하고 0으로 처리, 그 후 1 증가
      }

      memberCountList = memberCounts.values.toList(); // 인원수만 배열로
    });
  }
}
