import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:team_management_app/model/team.dart';
import 'package:team_management_app/model/user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:team_management_app/provider/userdata_provider.dart';

class ApiService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final dio.Dio _dio = dio.Dio(
    dio.BaseOptions(
      baseUrl: dotenv.env['API_SERVER']!,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'X-from': 'app',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  static final ApiService _apiService = ApiService._internal();

  ApiService._internal() {
    _dio.interceptors.add(dio.InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? accessToken = await _storage.read(key: 'access');
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
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
          try {
            if (await _refreshToken()) {
              // 토큰 갱신 성공 시, 원래 요청 다시 시도
              final options = e.requestOptions;
              // String? newAccessToken = await _storage.read(key: 'access');
              // if (newAccessToken != null) {
              //   options.headers['Authorization'] = 'Bearer $newAccessToken';
              //   log('New Authorization Header Added: Bearer $newAccessToken');
              // }
              final response = await _dio.fetch(options);
              return handler.resolve(response);
            }
          } catch (error) {
            log('Token refresh error: $error');
            return handler.next(e);
          } finally {}
        } else {
          log('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
        }
        return handler.next(e);
      },
    ));
  }

  static List<User> users = [];
  static ApiService get instance => _apiService;

// 토큰 재발급 함수
  Future<bool> _refreshToken() async {
    try {
      final response = await _dio.post(
        '/api/auth/token/refresh',
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.headers.value('access');
        await _storage.write(key: 'access', value: newAccessToken);
        log('Token refreshed successfully');
        return true;
      }

      if (response.statusCode == 401) {
        // TODO 로그아웃 구현
      }
    } catch (e) {
      log('Token refresh failed: $e');
    }
    return false;
  }

// 깃허브 로그인
  Future<void> signInWithGitHub(WidgetRef ref) async {
    final clientID = await _storage.read(key: 'clientID');
    if (clientID == null) {
      log('Client ID is null');
      return;
    }

    try {
      const String redirectUri = 'myapp://auth';
      String authUrl = 'https://github.com/login/oauth/authorize'
          '?client_id=$clientID&redirect_uri=$redirectUri';

      final String result = await FlutterWebAuth.authenticate(
          url: authUrl, callbackUrlScheme: "myapp");
      log('github 로그인 결과값 출력: $result');

      final String? code = Uri.parse(result).queryParameters['code'];
      log('github 로그인 후 code값 출력: $code');

      if (code != null) {
        final response = await _dio.post(
          '/api/auth/github/login',
          data: {'code': code}, // Code와 함께 로그인 요청
        );
        log('api/auth/github/login 응답 값: $response');
        if (response.statusCode == 200) {
          log('Success Github login');
          final accessToken = response.headers.value('access');
          if (accessToken != null) {
            await _storage.write(
                key: 'access',
                value: accessToken); // accessToken을 Flutter SecureStorage에 갱신하기
            log('FlutterSecureStorage에 accessToken을 성공적으로 갱신');
          }
          final userData = response.data as Map<String, dynamic>?;
          log('User data: $userData');

          // userData와 registered 키의 존재 여부 확인
          if (userData != null && userData.containsKey('registered')) {
            // 사용자 정보를 프로바이더에 설정합니다.
            ref.read(userProvider.notifier).state =
                userData; // user 데이터를 userProvider에 저장
            ref.read(loginStatusProvider.notifier).state =
                userData['registered'] as bool; // 로그인 상태를 true로 변경
          } else {
            log('User data does not contain "registered" key');
          }
        } else {
          log('Failed to login. Status code: ${response.statusCode}, response: ${response.data}');
        }
      } else {
        log('Authorization code is null');
      }
    } on PlatformException catch (e) {
      if (e.code == 'CANCELED') {
        log('유저에 의한 로그인 취소: $e');
        _showRetryDialog(ref);
      } else {
        log('로그인 중 PlatformException 발생: $e');
      }
    } catch (e) {
      log('로그인 중 오류 발생: $e');
    }
  }

// 로그인이 취소되었을때 다시 시도하는 함수
  void _showRetryDialog(WidgetRef ref) {
    final context = ref.read(navigatorProvider).currentContext!;
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
                signInWithGitHub(ref); // 다시 시도
              },
            ),
          ],
        );
      },
    );
  }

  // 로그인 된 계정 로그아웃하기
  Future<void> logoutCurrentAccount() async {
    // // 로그아웃 URL 호출하여 세션 초기화
    await FlutterWebAuth.authenticate(
        url: 'https://github.com/logout', callbackUrlScheme: "myapp");
  }

  final navigatorProvider = Provider<GlobalKey<NavigatorState>>((ref) {
    return GlobalKey<NavigatorState>();
  });

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
