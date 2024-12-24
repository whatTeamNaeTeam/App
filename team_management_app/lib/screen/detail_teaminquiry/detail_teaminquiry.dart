import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:team_management_app/api_service/api_service.dart';
import 'package:team_management_app/assets/color/colors.dart';
import 'package:team_management_app/model/detail_teaminquiry_model.dart';
import 'package:team_management_app/screen/detail_teaminquiry/apply_container/apply_container_column.dart';
import 'package:team_management_app/screen/detail_teaminquiry/detail_teaminquiry_urls.dart';
import 'package:team_management_app/screen/entireappbar.dart';
import 'package:team_management_app/utils/buttons/widebutton.dart';

class DetailTeamInquiry extends StatefulWidget {
  final ApiResponse detailTeamData;
  const DetailTeamInquiry({
    super.key,
    required this.detailTeamData,
  });

  @override
  State<DetailTeamInquiry> createState() => _DetailTeamInquiry();
}

class _DetailTeamInquiry extends State<DetailTeamInquiry> {
  bool isLiked = false; // 좋아요 상태
  int likeCount = 0; // 좋아요 개수
  int version = 0;

  @override
  void initState() {
    super.initState();
    isLiked = widget.detailTeamData.team.isLike; // 초기 좋아요 상태 설정
    likeCount = widget.detailTeamData.team.like; // 초기 좋아요 개수 설정
    version = widget.detailTeamData.team.version;
  }

  // 좋아요 기능 구현
  Future<void> toggleLikeInDetailPage(int teamId) async {
    try {
      final response = await ApiService.instance.isLikeApi(teamId, version);

      setState(() {
        isLiked = response.like.isLike;
        likeCount = response.like.likeCount;
        version = response.version; // 서버에서 반환된 최신 version으로 업데이트
      });

      log(isLiked ? '좋아요가 눌렸습니다.' : '좋아요가 취소되었습니다.');
    } catch (e) {
      if (e is DioException) {
        log('서버 응답: ${e.response?.data}');
      }
      log('좋아요 기능 중 에러 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    const titleTextstyle = TextStyle(fontSize: 21, fontWeight: FontWeight.w600);

    return Scaffold(
      appBar: const EntireAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.detailTeamData.team.title, // 프로젝트 제목
                style: titleTextstyle,
              ),
              Row(
                children: [
                  Text(
                    widget.detailTeamData.team.leaderInfo.name, // 팀장 이름
                    style: const TextStyle(
                      color: Color(ButtonColors.gray6),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '조회수 ${widget.detailTeamData.team.view}',
                    style: const TextStyle(
                      color: Color(ButtonColors.gray6),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    '관심가지는 사람 $likeCount', // 좋아요 수 표시
                    style: const TextStyle(
                      color: Color(ButtonColors.gray6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                '프로젝트 설명', // 프로젝트 설명
                style: titleTextstyle,
              ),
              Markdown(
                shrinkWrap: true,
                data: widget.detailTeamData.team.explain.toString(),
                physics: const NeverScrollableScrollPhysics(),
              ),
              const SizedBox(height: 20),
              const Text(
                '필요 포지션',
                style: titleTextstyle,
              ),
              ApplyContainerColumn(
                category: widget.detailTeamData.team.category,
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 20),
              const Text(
                '관련 링크',
                style: titleTextstyle,
              ),
              UrlListView(),
              const SizedBox(height: 20),
              WideButton(
                buttonColor: ButtonColors.indigo4,
                textColor: ButtonColors.white,
                title: '지원하기',
                onPressed: () {},
              ),
              const SizedBox(height: 10),
              WideButton(
                buttonColor: isLiked
                    ? ButtonColors.red6 // 좋아요가 눌렸으면 빨간색
                    : ButtonColors.white, // 좋아요가 안 눌렸으면 흰색
                textColor: isLiked
                    ? ButtonColors.white // 좋아요가 눌렸으면 텍스트는 흰색
                    : ButtonColors.indigo4, // 안 눌렸으면 텍스트는 인디고색
                title: isLiked ? '좋아요 취소' : '좋아요', // 좋아요 상태에 따라 텍스트 변경
                onPressed: () => toggleLikeInDetailPage(
                  widget.detailTeamData.team.id,
                ), // 좋아요 기능 연결
              ),
            ],
          ),
        ),
      ),
    );
  }
}
