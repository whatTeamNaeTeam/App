import 'package:flutter/material.dart';
import 'package:team_management_app/screen/entireappbar.dart';

class Teaminquiry extends StatefulWidget {
  const Teaminquiry({super.key});

  @override
  State<Teaminquiry> createState() => _TeaminquiryState();
}

class _TeaminquiryState extends State<Teaminquiry> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: EntireAppbar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [Text("진행중")],
              )
            ],
          ),
        ),
      ),
    );
  }
}
