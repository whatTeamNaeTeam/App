import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:team_management_app/model/detail_teaminquiry_model.dart'
    as detailteamApiResponse;
import 'package:team_management_app/model/like_model.dart';
import 'package:team_management_app/model/team_model.dart';
import 'package:team_management_app/model/teaminquiry_model.dart'
    as teamApiResponse;
import 'package:team_management_app/model/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:team_management_app/model/userprofilemodel.dart';
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

  // 상태 플래그
  bool isRegistering = false;

  ApiService._internal() {
    _dio.interceptors.add(dio.InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 깃허브 로그인 경로는 인터셉터에서 제외
        if (options.path == '/api/auth/github/login') {
          return handler.next(options);
        }

        // 회원가입이 필요한 경우 tempToken 값을 사용한다.
        if (isRegistering || options.path == '/api/auth/github/finish') {
          String? tempToken = await _storage.read(key: 'temp');
          log("temp -> tempToken: $tempToken");
          if (tempToken != null) {
            options.headers['Authorization'] = 'Bearer $tempToken';
          } else {
            log('No Access Token Found in tempToken');
          }
        } else {
          // 회원가입이 필요 없는 경우 accessToken 값을 사용한다.
          String? accessToken = await _storage.read(key: 'access');
          log("access -> accessToken: $accessToken");
          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          } else if (accessToken == null) {
            log('No Access Token Found in accessToken');
          } else {
            log("An Error in AccessToken interceptor");
          }
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
              final options = e.requestOptions;
              String? newAccessToken = await _storage.read(key: 'access');
              if (newAccessToken != null) {
                options.headers['Authorization'] = 'Bearer $newAccessToken';
                log('New Authorization Header Added: Bearer $newAccessToken');
              }
              final response = await _dio.fetch(options);
              return handler.resolve(response);
            }
          } catch (error) {
            log('Token refresh error: $error');
            return handler.next(e);
          }
        } else {
          log('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
        }
        return handler.next(e);
      },
    ));
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

      final String? code = Uri.parse(result).queryParameters['code'];
      if (code != null) {
        final response = await _dio.post(
          '/api/auth/github/login',
          data: {'code': code},
        );
        log('api/auth/github/login 응답 값: $response');
        if (response.statusCode == 200) {
          final userData = response.data as Map<String, dynamic>?;
          final registered = userData?['registered']; // true, false 분기 설정
          final test = response.headers.value('access');
          final test2 = response.headers.value('temp');
          log('test1: $test');
          log('test2: $test2');
          if (userData != null && registered) {
            // true => 유저가 등록되어 있으면 accessToken 설정
            if (userData['registered'] as bool) {
              final accessToken = response.headers.value('access');
              if (accessToken != null) {
                await _storage.write(key: 'access', value: accessToken);
              }
              ref.read(userProvider.notifier).state = userData;
              ref.read(loginStatusProvider.notifier).state = true;
            } else {
              // 회원가입이 필요하다는 상태 플래그를 true로 설정
              isRegistering = true;
              final tempToken = response.headers.value('temp');
              if (tempToken != null) {
                await _storage.write(key: 'temp', value: tempToken);
              }
              ref.read(loginStatusProvider.notifier).state = false;
            }
          } else {
            log('User data does not contain "registered" key');
          }
        } else {
          log('Failed to login. Status code: ${response.statusCode}, response: ${response.data}');
        }
      } else {
        log('Authorization code is null');
      }
    } catch (e) {
      log('로그인 중 오류 발생: $e');
    }
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

  // 로그인 된 계정 로그아웃하기
  Future<void> logoutCurrentAccount() async {
    // // 로그아웃 URL 호출하여 세션 초기화
    await FlutterWebAuth.authenticate(
        url: 'https://github.com/logout', callbackUrlScheme: "myapp");
  }

  final navigatorProvider = Provider<GlobalKey<NavigatorState>>((ref) {
    return GlobalKey<NavigatorState>();
  });

// 추가적인 정보 기입 및 회원가입
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
        'title': projectTitle,
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

  // 팀 페이지 조회 API
  Future<teamApiResponse.ApiResponse> teamInquiry({String? cursor}) async {
    try {
      final response = await _dio.get(
        '/api/team/list',
        queryParameters: {
          'keyword': 'inprogress',
          if (cursor != null) 'cursor': cursor,
        },
      );

      if (response.statusCode == 200) {
        final apiResponse = teamApiResponse.ApiResponse.fromJson(response.data);
        return apiResponse;
      } else {
        log('Failed to load team list. Status code: ${response.statusCode}');
        throw Exception('Failed to load team list');
      }
    } catch (e) {
      log('Error during team inquiry: $e');
      rethrow;
    }
  }

  // 다음 페이지를 위한 커서 추출 메서드
  String? extractCursorFromUrl(String? url) {
    if (url == null) return null;
    final uri = Uri.parse(url);
    return uri.queryParameters['cursor'];
  }

// 좋아요 기능 API
  Future<Islike> isLikeApi(int teamId, int version) async {
    try {
      final response =
          await _dio.post('/api/like/$teamId', data: {'version': version});
      if (response.statusCode == 202) {
        final apiResponse = Islike.fromJson(response.data);
        return apiResponse;
      } else {
        log('Failed to load IsLike. Status code: ${response.statusCode}');
        throw Exception('Failed to load IsLike');
      }
    } catch (e) {
      log('Error during is Like: $e');
      rethrow;
    }
  }

// 팀 상세 페이지 조회
  Future<detailteamApiResponse.ApiResponse> detailTeamInquiry(
      int teamId) async {
    try {
      final response = await _dio.get('/api/team/detail/$teamId');
      if (response.statusCode == 200) {
        log('Response data: ${response.data}');
        // 응답 데이터를 로깅하여 실제 데이터 구조를 확인
        final apiResponse =
            detailteamApiResponse.ApiResponse.fromJson(response.data);
        return apiResponse;
      } else {
        log('Failed to load detail Team. Status code: ${response.statusCode}');
        log('Detail log: ${response.data}');
        throw Exception('Failed to load detail Team');
      }
    } catch (e) {
      log('Error during load detail team: $e');
      rethrow;
    }
  }

  // 팀 가입 신청
  Future<bool> teamapply(String bio, int categoryid) async {
    try {
      final response = await _dio.post(
        '/api/apply/$categoryid',
        data: {'bio': bio},
      );
      if (response.statusCode == 201) {
        log('성공적인 팀 지원');
        log('${response.data}');
        return true;
      } else {
        log('팀 지원 실패: ${response.data}');
        log('${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('팀 지원 시 알수없는 에러 발생: $e');
      rethrow;
    }
  }

  // 관심있는 팀 페이지 조회 API
  Future<teamApiResponse.ApiResponse> interestteamInquiry(
      {String? cursor}) async {
    try {
      final response = await _dio.get(
        '/api/team/list',
        queryParameters: {
          'keyword': 'inprogress',
          if (cursor != null) 'cursor': cursor,
        },
      );

      if (response.statusCode == 200) {
        final apiResponse = teamApiResponse.ApiResponse.fromJson(response.data);

        // 관심있는 팀 데이터 필터링 (is_like가 true인 팀만)
        final filteredResults =
            apiResponse.results.where((team) => team.isLike == true).toList();

        // 필터링된 결과를 포함한 새로운 ApiResponse 반환
        return teamApiResponse.ApiResponse(
          next: apiResponse.next,
          previous: apiResponse.previous,
          results: filteredResults,
        );
      } else {
        log('Failed to load team list. Status code: ${response.statusCode}');
        throw Exception('Failed to load team list');
      }
    } catch (e) {
      log('Error during team inquiry: $e');
      rethrow;
    }
  }

  // 유저 프로필 조회 API
  Future<UserProfile> fetchUserProfile(int userId) async {
    try {
      final response = await _dio.get('/api/user/profile/$userId');
      if (response.statusCode == 200) {
        return UserProfile.fromJson(response.data);
      } else {
        throw Exception('유저 프로필 조회 불러오기 실패');
      }
    } catch (e) {
      throw Exception('유저 프로필 조회 try 오류: $e');
    }
  }
}
