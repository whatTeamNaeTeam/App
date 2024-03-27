import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _storage = const FlutterSecureStorage();

  Future<void> signInWithGitHub() async {
    try {
      const clientId = 'YOUR_CLIENT_ID';
      const redirectUri = 'myapp://auth';
      const scope = 'read:user';

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
            'client_secret': 'YOUR_CLIENT_SECRET',
            'code': code,
          }),
        );

        final accessToken = jsonDecode(response.body)['access_token'];

        if (accessToken != null) {
          await _storage.write(key: 'github_access_token', value: accessToken);
          // 여기서 사용자 정보를 가져오거나 다음 단계로 넘어갈 수 있습니다.
        }
      }
    } catch (e) {
      if (!mounted) return;
      if (e is PlatformException && e.code == "CANCELED") {
        // 사용자가 로그인을 취소한 경우 처리
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("로그인이 취소되었습니다. 다시 시도해주세요.")),
        );
      } else {
        // 다른 예외 처리
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("로그인 중 오류가 발생했습니다. 다시 시도해주세요.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            signInWithGitHub();
          },
          child: const Text('GitHub으로 로그인하기'),
        ),
      ),
    );
  }
}
