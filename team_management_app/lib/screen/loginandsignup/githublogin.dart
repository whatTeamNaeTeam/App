import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_management_app/api_service/api_service.dart';
import 'package:team_management_app/assets/color/colors.dart';
import 'package:team_management_app/screen/loginandsignup/moresignup.dart';
import 'package:team_management_app/provider/userdata_provider.dart';
import 'package:team_management_app/screen/main-screen/mainscreen.dart';
import 'package:team_management_app/utils/screen_size_util.dart';

class GithubLogin extends ConsumerStatefulWidget {
  const GithubLogin({super.key});

  @override
  ConsumerState<GithubLogin> createState() => GithubLoginState();
}

class GithubLoginState extends ConsumerState<GithubLogin> {
  void signIn() async {
    await ApiService.instance.signInWithGitHub(ref);
    bool result = ref
        .read(loginStatusProvider.notifier)
        .state; // 전체 상태관리에서 login 처리가 되었는지 불러오기
    log('github result: $result');
    if (!result) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignupPage(),
        ),
      );
    }
  }

  void logoutAccount() async {
    await ApiService.instance.logoutCurrentAccount();
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(loginStatusProvider);

    return Scaffold(
      body: Center(
        child: isLoggedIn
            ? const MainScreen() // 로그인 성공 시 메인페이지로 넘어가기 - 팀 조회 페이지
            : SizedBox(
                width: ScreenSizeUtil.screenWidth(context) * 0.65,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/wap_icon.png',
                      width: 60,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                          (states) {
                            if (states.contains(MaterialState.pressed)) {
                              return const Color(
                                  ButtonColors.gray4); // 눌렸을 때 색상
                            }
                            return const Color(ButtonColors.black); // 기본 색상
                          },
                        ),
                        minimumSize: MaterialStateProperty.all<Size>(
                          const Size(double.infinity, 45), // 버튼 최소 크기 설정
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // 버튼 모서리 둥글게
                          ),
                        ),
                        overlayColor: MaterialStateProperty.all<Color>(
                          const Color(ButtonColors.white)
                              .withOpacity(0.1), // 눌림 효과 색상
                        ),
                      ),
                      onPressed: signIn,
                      icon: Image.asset(
                        'assets/icons/github_icon.png', // 여기에 GitHub 아이콘 경로를 넣습니다.
                        width: 24,
                        height: 24,
                        color: const Color(ButtonColors.white),
                      ),
                      label: const Text(
                        '깃허브로 시작하기',
                        style: TextStyle(
                            color: Color(ButtonColors.white), fontSize: 14),
                        overflow: TextOverflow.ellipsis, // 텍스트가 넘칠 경우 생략 표시
                      ),
                    ),
                    const SizedBox(height: 10), // 버튼과 텍스트 사이의 간
                    const Text(
                      '로그인 시 WAP의 개인정보처리방침과 이용 약관에 동의한 것으로 간주합니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(ButtonColors.gray4), fontSize: 12),
                    ),
                    TextButton(
                      onPressed: logoutAccount,
                      child: const Text('로그인 계정 삭제'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
