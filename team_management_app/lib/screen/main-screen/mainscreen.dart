import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_management_app/api_service/api_service.dart';
import 'package:team_management_app/assets/color/colors.dart';
import 'package:team_management_app/model/userprofilemodel.dart';
import 'package:team_management_app/provider/userdata_provider.dart';
import 'package:team_management_app/screen/MyPage/mypage.dart';
import 'package:team_management_app/screen/custom_bottom_navigationbar.dart';
import 'package:team_management_app/screen/entireappbar.dart';
import 'package:team_management_app/screen/interest-team/interestteams.dart';
import 'package:team_management_app/screen/team-create/teamcreate.dart';
import 'package:team_management_app/screen/teaminquiry/teaminquiry.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _staticWidgetOptions = <Widget>[
    Teaminquiry(), // 메인 페이지
    InterestTeams(), // 관심 페이지
    TeamCreate(), // 팀 생성 페이지
  ];

  // 마이페이지 데이터를 불러오는 함수
  Future<UserProfile> loadMyPageAPI() async {
    final user = ref.watch(userProvider)?['user'];
    final int userId = user['id'];

    // API를 호출하고 UserProfile 데이터를 받음
    final profileData = await ApiService.instance.fetchUserProfile(userId);
    return profileData;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 2 ? null : const EntireAppbar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          ..._staticWidgetOptions,
          // 마이페이지 탭이 선택되면 FutureBuilder로 데이터를 로드하고 UI에 반영
          if (_selectedIndex == 3)
            FutureBuilder<UserProfile>(
              future: loadMyPageAPI(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator()); // 로딩 중일 때
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}')); // 오류 처리
                } else if (snapshot.hasData) {
                  return MyPage(
                      userProfile: snapshot.data!); // 데이터가 있으면 MyPage 로드
                } else {
                  return const Center(
                      child: Text('No data available')); // 데이터가 없을 때
                }
              },
            ),
        ],
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
