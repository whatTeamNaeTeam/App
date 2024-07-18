import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:team_management_app/model/team.dart';
import 'package:team_management_app/model/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final dio.Dio _dio = dio.Dio(dio.BaseOptions(
    baseUrl: dotenv.env['API_SERVER']!,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
    headers: {
      'X-from': 'app',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  static final ApiService _apiService = ApiService._internal();

  ApiService._internal() {
    _dio.interceptors.add(dio.InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? accessToken = await _storage.read(key: 'access');
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
          log('Authorization Header Added: Bearer $accessToken');
        } else {
          log('No Access Token Found');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        log('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (dio.DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // 토큰 갱신 로직
          if (await _refreshToken()) {
            // 토큰 갱신 성공 시, 원래 요청 다시 시도
            final options = e.requestOptions;
            String? newAccessToken = await _storage.read(key: 'access');
            if (newAccessToken != null) {
              options.headers['Authorization'] = 'Bearer $newAccessToken';
              log('New Authorization Header Added: Bearer $newAccessToken');
            }
            final cloneReq = await _dio.request(
              options.path,
              options: dio.Options(
                method: options.method,
                headers: options.headers,
                contentType: options.contentType,
                responseType: options.responseType,
                followRedirects: options.followRedirects,
                validateStatus: options.validateStatus,
                receiveDataWhenStatusError: options.receiveDataWhenStatusError,
                extra: options.extra,
              ),
              data: options.data,
              queryParameters: options.queryParameters,
            );
            return handler.resolve(cloneReq);
          }
        }
        log('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
        return handler.next(e);
      },
    ));
  }

  static List<User> users = [];
  static ApiService get instance => _apiService;

// 토큰 재발급 함수
  Future<bool> _refreshToken() async {
    try {
      final response = await _dio.post('/api/auth/token/refresh');

      if (response.statusCode == 200) {
        final newAccessToken = response.headers['access']?.first;
        if (newAccessToken != null) {
          await _storage.write(key: 'access', value: newAccessToken);
          return true;
        }
      }
      return false;
    } catch (e) {
      log('Refresh Token Error: $e');
      return false;
    }
  }

// 깃허브 소셜 로그인 함수
  Future<bool> signInWithGitHub(BuildContext context) async {
    final clientID = await _storage.read(key: 'clientID');
    if (clientID == null) {
      log('Client ID is null');
      return false;
    }

    try {
      const String redirectUri = 'myapp://auth';
      String authUrl = 'https://github.com/login/oauth/authorize'
          '?client_id=$clientID&redirect_uri=$redirectUri';

      final String result = await FlutterWebAuth.authenticate(
          url: authUrl, callbackUrlScheme: "myapp");

      final String? code = Uri.parse(result).queryParameters['code'];

      if (code != null) {
        final response = await _dio.post(
          '/api/auth/github/login',
          data: {'code': code},
        );

        if (response.statusCode == 200) {
          log('Success Github login');
          final accessToken = response.headers.value('access');
          if (accessToken != null) {
            await _storage.write(key: 'access', value: accessToken);
            log('accessToken: $accessToken');
          }
          var userData = response.data;
          log('User data: $userData');
          return userData['registered'];
        } else {
          log('Failed to login. Status code: ${response.statusCode}, response: ${response.data}');
          return false;
        }
      } else {
        log('Authorization code is null');
        return false;
      }
    } on PlatformException catch (e) {
      if (e.code == 'CANCELED') {
        log('Login canceled by user: $e');
        _showRetryDialog(context);
      } else {
        log('PlatformException during login: $e');
      }
      return false;
    } catch (e) {
      log('Exception during login: $e');
      return false;
    }
  }

// 로그인이 취소되었을때 다시 시도하는 함수
  void _showRetryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그인 취소'),
          content: const Text('로그인이 취소되었습니다. 다시 시도하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('다시 시도'),
              onPressed: () {
                Navigator.of(context).pop();
                signInWithGitHub(context); // 다시 시도
              },
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> registerUser(String studentId, String name,
      String position, String email, String emailCode) async {
    try {
      var response = await _dio.post('/api/auth/github/finish', data: {
        'student_num': studentId,
        'name': name,
        'position': position,
        'email': email,
        'code': emailCode,
      });

      if (response.statusCode == 201) {
        log('Registration successful');
        return {'success': true, 'data': response.data};
      } else {
        log('Failed to register. Status code: ${response.statusCode}, Body: ${response.data}');
        return {'success': false, 'data': response.data};
      }
    } on dio.DioException catch (e) {
      log('DioException occurred: $e');
      if (e.response != null) {
        log('Response status: ${e.response?.statusCode}');
        log('Response data: ${e.response?.data}');
      }
      return {'success': false, 'data': null};
    } catch (e) {
      log('An error occurred: $e');
      return {'success': false, 'data': null};
    }
  }

  Future<String> emailSend(email) async {
    try {
      var response = await _dio.post('/api/auth/email', data: {
        'email': email,
      });
      if (response.statusCode == 200) {
        log('Email sent successfully: $response');
        return 'success';
      } else {
        log('Email send error: ${response.statusCode}, ${response.data}');
        return 'error';
      }
    } on dio.DioException catch (e) {
      log('DioException occurred: $e');
      if (e.response != null) {
        log('Response status: ${e.response?.statusCode}');
        log('Response data: ${e.response?.data}');
      }
      return 'error';
    } catch (e) {
      log('An error occurred: $e');
      return 'error';
    }
  }

  Future<bool> emailCodeVerify(TextEditingController emailController,
      TextEditingController emailCodeController) async {
    try {
      final email = emailController.text;
      final emailCode =
          emailCodeController.text; // TextEditingController에서 텍스트 값을 가져옴
      log('emailCode: $emailCode');
      var response = await _dio.patch('/api/auth/email', data: {
        'email': email,
        'code': emailCode,
      });
      if (response.statusCode == 200) {
        log('이메일 인증 완료');
        return true;
      } else {
        log('이메일 인증 실패');
        return false;
      }
    } on dio.DioException catch (e) {
      log('DioException occurred: $e');
      if (e.response != null) {
        log('Response status: ${e.response?.statusCode}');
        log('Response data: ${e.response?.data}');
      }
      return false;
    } catch (e) {
      log('An error occurred: $e');
      return false;
    }
  }

  Future<void> getUsers() async {
    try {
      final response = await _dio.get('/api/admin/user/manage');
      if (response.statusCode == 200) {
        var data = response.data;
        if (data is List) {
          users.clear();
          for (var userJson in data) {
            users.add(User.fromJson(userJson));
          }
        } else {
          log("Error: Expected a list of users but got something else.");
        }
      } else {
        log('Failed to load getUsers from server with status code ${response.statusCode}');
      }
    } catch (e) {
      log("Error getUsers() from api_service.dart: $e");
    }
  }

  Future<void> approveUsers(int userid) async {
    try {
      final response = await _dio.patch('/api/user/manage/$userid',
          data: json.encode({'is_approved': 'true'}));

      if (response.statusCode == 200) {
        log("User approved successfully.");
      } else {
        log("Failed to approve user. Status code: ${response.statusCode}");
      }
    } catch (e) {
      log("Error approveUsers: $e");
    }
  }

  Future<bool> createNewTeam(projectTitle, projectGenre, projectFields,
      memberCountList, markdownText, file, projectURL) async {
    try {
      var formData = dio.FormData.fromMap({
        'name': projectTitle,
        'explain': markdownText,
        'genre': projectGenre,
        'urls': projectURL,
        'subCategory': projectFields.join(','),
        'memberCount': memberCountList.join(','),
      });

      if (file != null) {
        formData.files.add(MapEntry(
          'image',
          await dio.MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last),
        ));
      }

      var response = await _dio.post('/api/team/create', data: formData);
      if (response.statusCode == 201) {
        log('Registration successful');
        return true;
      } else {
        log('Failed to register. Status code: ${response.statusCode}, Body: ${response.data}');
        return false;
      }
    } catch (e) {
      log('Create New Team Error Occurred: $e');
      return false;
    }
  }

  Future<void> getunApproveTeams(List<UnapproveTeam> unapproveTeams) async {
    try {
      final response = await _dio.get('/api/admin/team/manage');
      log('Response body: ${response.data}');

      if (response.statusCode == 200) {
        var data = response.data;
        if (data is List) {
          unapproveTeams.clear();
          for (var teamJson in data) {
            unapproveTeams.add(UnapproveTeam.fromJson(teamJson));
          }
        } else {
          log("getunApproveTeams : Error => Expected a list of teams but got something else.");
        }
      } else {
        log('Failed to load getUsers from server with status code ${response.statusCode}');
      }
    } catch (e) {
      log("Error getunApproveTeams: $e");
    }
  }

  Future<void> approveTeams(int teamid) async {
    try {
      final response = await _dio.patch('/api/admin/team/manage/$teamid',
          data: json.encode({'success': 'true'}));

      if (response.statusCode == 200) {
        log("approveTeams : Team approved successfully.");
      } else {
        log("approveTeams : Failed to approve team. Status code: ${response.statusCode}");
      }
    } catch (e) {
      log("approveTeams : Error approveTeams: $e");
    }
  }
}
