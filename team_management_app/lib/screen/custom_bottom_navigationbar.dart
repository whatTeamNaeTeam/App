import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_management_app/assets/color/colors.dart';
import 'package:team_management_app/provider/userdata_provider.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int selectedColor;
  final int unSelectedColor;

  const CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    required this.selectedColor,
    required this.unSelectedColor,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)?['user'];
    final String? imageUrl = user?['image_url']; // 로그인시 받아오는 ImageUrl을 설정하기
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white, // 바탕색
        boxShadow: [
          BoxShadow(
            color: Color(ButtonColors.gray2), // 그림자 색상
            blurRadius: 10, // 그림자 흐림 정도
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: '관심',
            ),
            BottomNavigationBarItem(
              icon: currentIndex == 2
                  ? Image.asset(
                      'assets/icons/teamCreate_indigo4.png',
                      width: 24,
                      height: 24,
                    )
                  : Image.asset(
                      'assets/icons/teamCreate_gray5.png',
                      width: 24,
                      height: 24,
                    ),
              label: '팀생성',
            ),
            BottomNavigationBarItem(
              icon: imageUrl != null
                  ? ClipOval(
                      child: Image.network(
                        imageUrl,
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.person),
              label: '마이페이지',
            ),
          ],
          currentIndex: currentIndex,
          selectedItemColor: Color(selectedColor),
          unselectedItemColor: Color(unSelectedColor),
          onTap: (index) {
            if (index == currentIndex) {
              return; // 이미 선택된 항목일 때는 아무 동작도 하지 않음
            }
            onTap(index);
          },
        ),
      ),
    );
  }
}
