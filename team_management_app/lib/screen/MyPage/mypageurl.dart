import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:team_management_app/assets/color/colors.dart';
import 'package:team_management_app/model/userprofilemodel.dart';
import 'package:url_launcher/url_launcher.dart'; // URL을 열기 위한 패키지

class MyPageUrls extends StatelessWidget {
  final List<Url> urls;

  const MyPageUrls({super.key, required this.urls});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: urls.map((urlData) {
        final url = urlData.url;
        final domainIcon = _getDomainIcon(url); // 도메인에 맞는 아이콘 가져오기
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              // 링크와 아이콘 부분
              Expanded(
                child: InkWell(
                  onTap: () => _launchURL(url), // URL 클릭 시 실행
                  child: Row(
                    children: [
                      domainIcon, // 도메인 아이콘 표시
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          url,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(ButtonColors.black),
                          ),
                          overflow: TextOverflow.ellipsis, // 긴 링크는 잘림 표시
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10), // 링크와 편집 버튼 사이 간격 추가
              // 편집 버튼
              InkWell(
                onTap: () => log('편집 버튼 $url 클릭'),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(ButtonColors.indigo4),
                    ),
                  ),
                  child: const Text(
                    '편집',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(ButtonColors.indigo4), // 텍스트 색상
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // 도메인에 따라 아이콘 선택
  Widget _getDomainIcon(String url) {
    if (url.contains('github.com')) {
      return Image.asset(
        'assets/icons/github-mark.png',
        width: 24,
      ); // GitHub 아이콘
    } else if (url.contains('daum.net')) {
      return const Icon(Icons.web, color: Colors.orange); // Daum 아이콘
    } else if (url.contains('google.com')) {
      return Image.asset(
        'assets/icons/google-logo.png',
        width: 24,
      ); // Google 아이콘
    } else if (url.contains('notion.so')) {
      return Image.asset(
        'assets/icons/Notion_app_logo.png',
        width: 24,
      );
    } else {
      return const Icon(
        Icons.link,
        color: Colors.grey,
        size: 24,
      ); // 일반 링크 아이콘
    }
  }

  // URL 실행 메서드
  Future<void> _launchURL(String url) async {
    try {
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://$url';
      }

      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      log('Error launching URL: $e');
    }
  }
}
