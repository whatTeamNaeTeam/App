import 'package:flutter/material.dart';
import 'package:team_management_app/screen/entireappbar.dart';

class TeamManagement extends StatefulWidget {
  const TeamManagement({super.key});

  @override
  State<TeamManagement> createState() => _TeamManagementState();
}

class _TeamManagementState extends State<TeamManagement> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: EntireAppbar(),
      body: Column(
        children: [
          Text(
            "팀 관리 페이지",
          ),
        ],
      ),
    );
  }
}
