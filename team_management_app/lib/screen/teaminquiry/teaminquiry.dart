import 'package:flutter/material.dart';

class Teaminquiry extends StatefulWidget {
  const Teaminquiry({super.key});

  @override
  State<Teaminquiry> createState() => _TeaminquiryState();
}

class _TeaminquiryState extends State<Teaminquiry> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('팀 조회 페이지'),
    );
  }
}
