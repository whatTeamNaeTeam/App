import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:team_management_app/api_service/loadapiaddress.dart';
import 'package:team_management_app/screen/moresignup.dart';
import 'package:team_management_app/service/storage_service.dart';
import 'package:team_management_app/model/user.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _signurl = LoadAPIAddress.loginapiurl();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  // API_Service 싱글톤 패턴
  static final ApiService _apiService = ApiService._internal();

  ApiService._internal(); // 싱글톤 객체 생성
  static List<User> users = [];
  static ApiService get instance => _apiService;

// 회원 승인용 api
  Future<void> getUsers() async {
    String manageurl = LoadAPIAddress.manageapiurl();
    String? accessToken = await _storage.read(key: 'access');
    if (accessToken == null) {
      print("Access token is null.");
      return; // Access token이 없으면 함수 종료
    }

    try {
      final response = await http.get(
        Uri.parse(manageurl),
        headers: {
          'X-from': 'app',
          'Authorization': 'Bearer $accessToken',
        },
      );
      print('Response status: ${response.statusCode}');

      // Explicitly decode the response body as UTF-8
      String responseBody = utf8.decode(response.bodyBytes);
      print('Response body: $responseBody'); // 응답 내용 로깅

      if (response.statusCode == 200) {
        var data = json.decode(responseBody);
        if (data is List) {
          users.clear();
          for (var userJson in data) {
            users.add(User.fromJson(userJson));
          }
        } else {
          print("Error: Expected a list of users but got something else.");
        }
      } else {
        print(
            'Failed to load getUsers from server with status code ${response.statusCode}');
      }
    } catch (e) {
      print("Error getUsers() from api_service.dart: $e");
    }
  }

  // 관리자페이지에서 회원 승인
  Future<void> approveUsers(int userid) async {
    String approveurl = LoadAPIAddress.approveurl(userid);
    String? accessToken = await _storage.read(key: 'access');
    print(accessToken);
    var url = Uri.parse(approveurl);
    try {
      final response = await http.patch(url,
          headers: {
            'Content-Type': 'application/json', // JSON 형식 명시
            'X-from': 'app',
            'Authorization': 'Bearer $accessToken',
          },
          body: json.encode({
            'is_approved': 'true' // JSON 문자열로 변환
          }));

      if (response.statusCode == 200) {
        print("User approved successfully.");
      } else {
        print("Failed to approve user. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error approveUsers: $e");
    }
  }

  // github 로그인
  Future<bool> signInWithGitHub(BuildContext context) async {
    final clientID =
        await StorageService.readClientID(); // StorageService에서 ClientID 읽어오기
    if (clientID == null) {
      return false; // Client ID 오류
    }
    try {
      const String redirectUri = 'myapp://auth';
      String authUrl =
          'https://github.com/login/oauth/authorize?client_id=$clientID&redirect_uri=$redirectUri';

      final String result = await FlutterWebAuth.authenticate(
          url: authUrl, callbackUrlScheme: "myapp");

      final String? code = Uri.parse(result).queryParameters['code'];

      if (code != null) {
        final response = await http.post(
          Uri.parse(_signurl),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'X-from': 'app',
          },
          body: jsonEncode({'code': code}),
        );

        if (response.statusCode == 200) {
          await _storage.write(
              key: 'access', value: response.headers['access']);
          var userData = jsonDecode(response.body);
          return userData['registered'];
        }
      }
      return true;
    } catch (e) {
      print('로그인 중 오류 발생: $e');
      return false;
    }
  }

// TODO 거절 로직

// 추가적인 회원가입 정보 등록 API
  Future<bool> registerUser() async {
    final String signupurl = LoadAPIAddress.signupapiurl();
    String? accessToken = await _storage.read(key: 'access');
    var url = Uri.parse(signupurl);
    try {
      var response = await http.post(url, headers: {
        'Authorization': 'Bearer $accessToken',
      }, body: {
        'student_num': SignupPageState.nameController.text,
        'name': SignupPageState.studentIdController.text,
        'position': SignupPageState.positionController,
      });

      if (response.statusCode == 201) {
        print('Registration successful');
        return true;
      } else {
        print(
            'Failed to register. Status code: ${response.statusCode}, Body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }
}
