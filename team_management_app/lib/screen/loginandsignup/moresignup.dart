import 'package:flutter/material.dart';
import 'package:list_picker/list_picker.dart';
import 'package:team_management_app/api_service/api_service.dart';
import 'package:team_management_app/assets/color/colors.dart';
import 'package:team_management_app/screen/loginandsignup/githublogin.dart';
import 'package:team_management_app/utils/screen_size_util.dart';
import 'package:team_management_app/utils/uppercase_text_input_formatter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  TextEditingController studentIdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController verificationCodeController = TextEditingController();

  bool showVerificationField = false;
  bool emailVerified = false;
  List<String> positions = ['프론트엔드', '백엔드', 'AI', '디자이너'];

  void attemptRegistration() async {
    if (studentIdController.text.isEmpty ||
        nameController.text.isEmpty ||
        positionController.text.isEmpty ||
        emailController.text.isEmpty ||
        verificationCodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 값을 입력해주세요.')),
      );
      return;
    } else {
      Map<String, dynamic> result = await ApiService.instance.registerUser(
          studentIdController.text,
          nameController.text,
          positionController.text,
          emailController.text,
          verificationCodeController.text);
      if (result['success'] && mounted) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const GithubLogin()));
      }
    }
  }

  void cancelRegistration() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('취소 확인'),
            content: const Text('취소하시겠습니까?'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  if (!mounted) return;
                  Navigator.of(context).pop();
                  await storage.deleteAll();
                  if (!mounted) return;
                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GithubLogin(),
                    ),
                  );
                },
                child: const Text('예'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('아니오')),
            ],
          );
        });
  }

  // 정규식을 사용한 이메일 유효성 검사
  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void emailAuthentication() async {
    if (!isValidEmail(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('유효한 이메일 주소를 입력하세요.')),
      );
      return;
    }

    var result = await ApiService.instance.emailSend(emailController.text);
    if (result == 'success') {
      if (!mounted) return;
      setState(() {
        showVerificationField = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('인증 번호가 이메일로 전송되었습니다.')),
      );
    } else if (result == 'error') {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일 전송에 실패했습니다. 다시 시도하세요.')),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('서버 오류가 발생했습니다. 나중에 다시 시도하세요.')),
      );
    }
  }

  void verifyCode() async {
    bool verified = await ApiService.instance
        .emailCodeVerify(emailController, verificationCodeController);
    if (!mounted) return;
    setState(() {
      emailVerified = verified;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(emailVerified ? '인증 완료되었습니다.' : '인증 실패했습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.0),
                // 이름 입력
                const Text('이름'),
                const SizedBox(height: 5),
                SizedBox(
                  height: 60,
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // 학번 입력
                const Text('학번'),
                const SizedBox(height: 5),
                SizedBox(
                  height: 60,
                  child: TextField(
                    controller: studentIdController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // 주포지션 입력
                const Text('주포지션'),
                const SizedBox(height: 5),
                ListPickerField(
                  label: '',
                  items: positions,
                  controller: positionController,
                ),
                const SizedBox(height: 10),
                // 이메일 입력
                const Text('이메일'),
                const SizedBox(height: 5),
                Row(
                  children: [
                    SizedBox(
                      width: ScreenSizeUtil.screenWidth(context) * 0.6,
                      height: 60,
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (!showVerificationField) ...[
                      TextButton(
                        onPressed: emailAuthentication,
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(ButtonColors.indigo4),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                        child: const Text('인증'),
                      ),
                    ],
                    if (showVerificationField) ...[
                      TextButton(
                        onPressed: emailAuthentication,
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(ButtonColors.gray6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                        child: const Text('재전송'),
                      ),
                    ]
                  ],
                ),
                if (showVerificationField) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: ScreenSizeUtil.screenWidth(context) * 0.3,
                        height: 60,
                        child: TextField(
                          // inputFormatters: [UpperCaseTextInputFormatter()],
                          controller: verificationCodeController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                            hintText: '인증번호',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: emailVerified ? null : verifyCode,
                        style: TextButton.styleFrom(
                          backgroundColor: emailVerified
                              ? const Color(ButtonColors.gray4)
                              : const Color(ButtonColors.indigo4),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                        child: const Text('확인'),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), // 최소 크기 설정
                    backgroundColor: const Color(
                      ButtonColors.indigo4,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        6,
                      ),
                    ),
                  ),
                  onPressed: attemptRegistration, // 버튼 클릭 시 실행할 함수
                  child: const Text(
                    '완료하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50), // 최소 크기 설정
                    backgroundColor: Colors.white,
                    shadowColor: const Color(ButtonColors.gray4).withOpacity(1),
                    // elevation: 1,
                    side: const BorderSide(
                      color: Color(ButtonColors.gray4),
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        6,
                      ),
                    ),
                  ),
                  onPressed: cancelRegistration, // 버튼 클릭 시 실행할 함수
                  child: const Text(
                    '취소하기',
                    style: TextStyle(
                      color: Color(ButtonColors.indigo4),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
