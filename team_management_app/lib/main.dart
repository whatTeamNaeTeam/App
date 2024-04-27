import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:team_management_app/screen/entireappbar.dart';
import 'screen/githublogin.dart'; // GitHub 로그인 위젯을 포함하기 위한 임포트
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  const storage = FlutterSecureStorage();
  final clientID = dotenv.env['CLIENT_ID'];

  if (clientID != null) {
    await storage.write(key: 'clientID', value: clientID);
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const Scaffold(
        appBar: EntireAppbar(),
        body: GithubLogin(), // 통합된 GitHub 로그인 페이지
      ),
    );
  }
}
