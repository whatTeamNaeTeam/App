import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // URL을 열기 위한 패키지

class UrlListView extends StatelessWidget {
  final List<String> _urls = [
    'https://www.daum.net',
    'https://github.com/fnzksxl123',
    'https://www.google.com',
    'https://www.notion.so',
  ];

  UrlListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화
      shrinkWrap: true,
      itemCount: _urls.length,
      itemBuilder: (context, index) {
        final url = _urls[index];
        final domainIcon = _getDomainIcon(url); // 도메인에 맞는 아이콘 가져오기
        return ListTile(
          leading: domainIcon, // 도메인에 맞는 아이콘 표시
          title: Text(url),
          onTap: () => _launchURL(url), // URL 클릭 시 브라우저로 열기
        );
      },
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
