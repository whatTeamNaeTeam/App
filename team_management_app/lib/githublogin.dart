import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'testui.dart'; // 이 부분은 'testui.dart' 파일에 Testui 클래스가 정의되어 있어야 합니다.

class GithubLogin extends StatefulWidget {
  const GithubLogin({super.key});

  @override
  State<GithubLogin> createState() => GithubLoginState();
}

class GithubLoginState extends State<GithubLogin> {
  bool isLoggedIn = false;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> signInWithGitHub() async {
    try {
      const clientId = 'e43a740bcfcc94adf542'; // GitHub에서 발급받은 Client ID
      const redirectUri = 'myapp://auth'; // 앱 설정에 맞는 redirectUri
      const scope = 'read:user'; // 필요한 권한
      const clientSecret =
          '9ae4b54e43e2f03db44ecb2adc17f708ab939ae0'; // 여기에 실제 client_secret 입력

      const authUrl =
          'https://github.com/login/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&scope=$scope';

      final result = await FlutterWebAuth.authenticate(
          url: authUrl, callbackUrlScheme: "myapp");

      final code = Uri.parse(result).queryParameters['code'];

      if (code != null) {
        final response = await http.post(
          Uri.parse('https://github.com/login/oauth/access_token'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'client_id': clientId,
            'client_secret': clientSecret,
            'code': code,
          }),
        );

        print('Response status: ${response.statusCode}'); // 응답 코드 로깅
        print('Response body: ${response.body}'); // 응답 본문 로깅

        if (response.statusCode == 200) {
          final accessToken = jsonDecode(response.body)['access_token'];
          if (accessToken != null) {
            await _storage.write(
                key: 'github_access_token', value: accessToken);
            setState(() {
              isLoggedIn = true;
              print('Logged in, setting state...'); // 상태 업데이트 로그
            });
          } else {
            print('Failed to receive access token.'); // 토큰 수신 실패 로그
          }
        } else {
          print(
              'Failed to fetch access token. Response status: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (!mounted) return;
      print('Error during login: $e'); // 로그인 중 오류 발생 로그
      if (e is PlatformException && e.code == 'CANCELED') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("로그인이 취소되었습니다. 다시 시도해주세요.")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("로그인 중 오류가 발생했습니다: ${e.toString()}")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoggedIn
            ? const Testui() // 로그인 성공 시 Testui 위젯 표시
            : ElevatedButton(
                onPressed: signInWithGitHub,
                child: const Text('Login with GitHub'),
              ),
      ),
    );
  }
}
