import 'package:flutter/material.dart';
import 'package:team_management_app/screen/entireappbar.dart';

class Teaminquiry extends StatefulWidget {
  const Teaminquiry({super.key});

  @override
  State<Teaminquiry> createState() => _TeaminquiryState();
}

class _TeaminquiryState extends State<Teaminquiry> {
  List<Map<String, Object>> results = [
    {
      "id": 3,
      "name": "test3",
      "image":
          "https://wtnt-bucket.s3.ap-northeast-2.amazonaws.com/team/test3/image.jpg",
      "category": [
        {"id": 6, "tech": "자바스프링", "need_num": 2, "current_num": 0},
        {"id": 5, "tech": "크로스플랫폼", "need_num": 3, "current_num": 0}
      ],
      "leader_id": 2,
      "leader_name": "강태원",
      "like": 1,
      "version": 5,
      "view": 0,
      "genre": "웹",
      "is_like": true
    },
    {
      "id": 4,
      "name": "test4",
      "image":
          "https://wtnt-bucket.s3.ap-northeast-2.amazonaws.com/team/test4/image.jpg",
      "category": [],
      "leader_id": 2,
      "leader_name": "강태원",
      "like": 0,
      "version": 0,
      "view": 0,
      "genre": "안드로이드",
      "is_like": false
    }
  ];
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: EntireAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [Text("진행중")],
            )
          ],
        ),
      ),
    );
  }
}
