import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:team_management_app/provider/userdata_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:team_management_app/screen/loginandsignup/githublogin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  const storage = FlutterSecureStorage();
  final clientID = dotenv.env['CLIENT_ID'];

  if (clientID != null) {
    await storage.write(key: 'clientID', value: clientID);
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final navigatorKey = ref.watch(navigatorKeyProvider);
        return MaterialApp(
          navigatorKey: navigatorKey, // navigatorKey 설정
          title: 'Flutter Demo',
          theme: ThemeData(),
          home: const Scaffold(
            body: GithubLogin(), // 통합된 GitHub 로그인 페이지
          ),
        );
      },
    );
  }
}
