import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:team_management_app/api_service/api_service.dart';
import 'package:team_management_app/assets/color/colors.dart';
import 'package:team_management_app/model/detail_teaminquiry_model.dart'
    as detailteamApiResponse;
import 'package:team_management_app/model/teaminquiry_model.dart';
import 'package:team_management_app/screen/detail_teaminquiry/detail_teaminquiry.dart';
import 'package:team_management_app/utils/screen_size_util.dart';

class Teaminquiry extends StatefulWidget {
  const Teaminquiry({super.key});

  @override
  State<Teaminquiry> createState() => _TeaminquiryState();
}

class _TeaminquiryState extends State<Teaminquiry> {
  List<Result> teamList = [];
  String? nextCursor;
  bool isLoading = false;
  bool isEndOfList = false; // 데이터의 끝에 도달했는지 여부를 나타내는 변수
  final ScrollController _scrollController = ScrollController();
  final int borderLineColor = ButtonColors.gray4;

  @override
  void initState() {
    super.initState();
    // 초기 데이터를 로드
    fetchTeams();
    // 스크롤 컨트롤러에 리스너 추가
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // 스크롤 컨트롤러에서 리스너 제거 및 컨트롤러 해제
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchTeams({bool refresh = false}) async {
    if (isLoading || isEndOfList) return;
    setState(() {
      isLoading = true;
    });

    try {
      // refresh가 true일 경우 데이터를 새로 불러옴
      if (refresh) {
        teamList.clear();
        nextCursor = null;
        isEndOfList = false;
      }

      // 팀 데이터를 API로부터 가져오기
      final response =
          await ApiService.instance.teamInquiry(cursor: nextCursor);
      setState(() {
        // 가져온 데이터를 리스트에 추가
        teamList.addAll(response.results);
        // 다음 페이지를 위한 커서 업데이트
        nextCursor = ApiService.instance.extractCursorFromUrl(response.next);
        if (response.results.isEmpty || nextCursor == null) {
          isEndOfList = true; // 더 이상 로드할 데이터가 없음
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log('Error fetching teams: $e');
    }
  }

  void _onScroll() {
    // 스크롤이 리스트 끝에 도달했을 때 다음 데이터를 로드
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      fetchTeams();
    }
  }

  // 맨 위로 스크롤하는 메서드
  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  // 좋아요 기능 만들기
  Future<void> toggleLike(int teamId, int index) async {
    try {
      final team = teamList[index];

      // 좋아요 API 호출
      final response =
          await ApiService.instance.isLikeApi(teamId, team.version);

      // 서버 응답에 따라 좋아요 상태 및 최신 version 값 업데이트
      setState(() {
        teamList[index] = team.copyWith(
          like: response.like.likeCount,
          isLike: response.like.isLike,
          version: response.version, // 서버에서 반환된 최신 version으로 업데이트
        );
      });
    } catch (e) {
      if (e is DioException) {
        log('서버 응답: ${e.response?.data}');
      }
      log('좋아요 기능 중 에러 발생: $e');
    }
  }

  // API로부터 데이터를 불러오기
  Future<detailteamApiResponse.ApiResponse> detailTeamInquiryAPI(
      int teamId) async {
    try {
      // API 요청 보내기
      final response = await ApiService.instance.detailTeamInquiry(teamId);
      // 요청이 성공적으로 완료되었을 경우, 데이터를 반환
      return response;
    } catch (e) {
      // 오류 발생 시 로그를 출력하고 예외를 던짐
      log('Error during detail team inquiry: $e');
      rethrow;
    }
  }

  Future<void> onClickTeam(BuildContext context, int teamId) async {
    final detailTeamData = await detailTeamInquiryAPI(teamId);
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailTeamInquiry(
          detailTeamData: detailTeamData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final teamUrlwidth = ScreenSizeUtil.screenWidth(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => fetchTeams(refresh: true), // 새로고침 시 데이터 새로 불러오기
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == teamList.length) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : isEndOfList
                                ? const Text('No more data')
                                : null,
                      ),
                    );
                  }
                  final team = teamList[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: InkWell(
                      onTap: () {
                        onClickTeam(context, team.id);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 0.5,
                            color: Color(borderLineColor),
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3), // 그림자 위치
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: Image.network(
                                team.imageUrl,
                                fit: BoxFit.cover,
                                width: teamUrlwidth,
                                height: teamUrlwidth * 0.66,
                              ),
                            ),
                            Divider(
                              color: Color(borderLineColor),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Row(
                                    children: [
                                      ClipOval(
                                        child: Image.network(
                                          team.leaderInfo.imageUrl,
                                          width: 25,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        team.leaderInfo.name,
                                      ),
                                      Text('${team.version}')
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    onPressed: () => toggleLike(team.id, index),
                                    icon: team.isLike
                                        ? const Icon(
                                            Icons.favorite,
                                            color: Color(ButtonColors.red9),
                                          )
                                        : const Icon(
                                            Icons.favorite_outline,
                                            color: Color(ButtonColors.gray6),
                                          ),
                                  ),
                                  Text('${team.like}'),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Text(
                                team.title,
                              ),
                            ),
                            Divider(
                              color: Color(borderLineColor),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: const Text(
                                '모집완료 0/4',
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: teamList.length + 1,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(ButtonColors.gray4),
        mini: true,
        onPressed: _scrollToTop,
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}
