import 'package:flutter/material.dart';
import 'package:team_management_app/api_service/api_service.dart';
import '../../main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  static TextEditingController studentIdController = TextEditingController();
  static TextEditingController nameController = TextEditingController();
  static TextEditingController positionController = TextEditingController();
  void attemptRegistration() async {
    bool success = await ApiService.instance.registerUser();
    if (success && mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const MyApp()));
    }
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
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    labelText: "이름을 입력하세요.",
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: studentIdController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    labelText: "학번을 입력하세요.",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: positionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    labelText: "주포지션을 입력하세요",
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: attemptRegistration,
                    child: const Text('가입하기'),
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
