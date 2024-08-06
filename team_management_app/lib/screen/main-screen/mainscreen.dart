import 'package:flutter/material.dart';
import 'package:team_management_app/assets/color/colors.dart';
import 'package:team_management_app/screen/MyPage/mypage.dart';
import 'package:team_management_app/screen/custom_bottom_navigationbar.dart';
import 'package:team_management_app/screen/entireappbar.dart';
import 'package:team_management_app/screen/interest-team/interestteams.dart';
import 'package:team_management_app/screen/team-create/teamcreate.dart';
import 'package:team_management_app/screen/teaminquiry/teaminquiry.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Teaminquiry(), // 메인 페이지
    InterestTeams(), // 관심 페이지
    TeamCreate(),
    MyPage(), // 마이 페이지
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 2) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 2 ? null : const EntireAppbar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedColor: ButtonColors.indigo4,
        unSelectedColor: ButtonColors.gray5,
      ),
    );
  }
}
