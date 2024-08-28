// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:team_management_app/api_service/api_service.dart';

import 'package:team_management_app/assets/color/colors.dart';
import 'package:team_management_app/model/detail_teaminquiry_model.dart';
import 'package:team_management_app/utils/discription_dialog.dart';

class ApplyContainerColumn extends StatefulWidget {
  final List<Category> category;

  const ApplyContainerColumn({
    super.key,
    required this.category,
  });

  @override
  State<ApplyContainerColumn> createState() => _ApplyContainerColumnState();
}

class _ApplyContainerColumnState extends State<ApplyContainerColumn> {
  Future<void> teamApply(int categoryid) async {
    log('지원하기 버튼이 눌렸음');

    // 현재의 context를 저장
    final currentContext = context;

    // 첫 번째 다이얼로그를 띄우고 사용자 입력을 기다림
    showDialog(
      context: context,
      builder: (context) => Builder(
        builder: (BuildContext dialogContext) {
          return DialogUI(
            title: '지원하기',
            discription: '지원 하시기 전 메시지를 남겨주세요.',
            onPressed: (String bio) async {
              // 첫 번째 다이얼로그 닫기
              Navigator.pop(dialogContext);

              // 비동기 작업 (팀 지원)
              bool success =
                  await ApiService.instance.teamapply(bio, categoryid);

              if (!mounted) return; // 위젯이 트리에서 제거되었는지 확인

              // 알림 표시: SnackBar
              ScaffoldMessenger.of(currentContext).showSnackBar(
                SnackBar(
                  content: Text(success ? '지원 성공!' : '지원 실패. 다시 시도해 주세요.'),
                  backgroundColor: success ? Colors.green : Colors.red,
                ),
              );

              // 작업 완료 후 다이얼로그 표시: AlertDialog
              showDialog(
                context: currentContext,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(success ? '지원 성공' : '지원 실패'),
                    content: Text(success
                        ? '팀 지원이 성공적으로 완료되었습니다.'
                        : '팀 지원에 실패했습니다. 다시 시도해 주세요.'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('확인'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

// 하드코딩.. 이게 맞냐...? 아 모르겠다~~
  String categorytitle(String title) {
    List<String> developTitles = [
      '웹',
      'iOS',
      '안드로이드',
      '크로스플랫폼',
      '자바',
      '파이썬',
      '노드',
      '유니티',
      '언리얼',
      '딥러닝',
      '머신러닝',
      '데이터 엔지니어',
    ];
    List<String> pmPlTitles = [
      'UI/UX 기획',
      '게임 기획',
      '컨텐츠 기획',
      '프로젝트 매니저',
    ];
    List<String> designTitles = ['게임 그래픽 디자인', 'UI/UX 디자인'];
    String result = '';

    for (String s in developTitles) {
      if (s.contains(title)) {
        result = '개발';
      }
    }

    for (String s in pmPlTitles) {
      if (s.contains(title)) {
        result = 'PM/기획';
      }
    }

    for (String s in designTitles) {
      if (s.contains(title)) {
        result = '디자인';
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 0.5,
          color: const Color(ButtonColors.gray4),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화
        itemCount: widget.category.length,
        itemBuilder: (context, index) {
          final cat = widget.category[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categorytitle(cat.title),
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                        color: Color(
                          ButtonColors.indigo4,
                        ),
                      ),
                    ),
                    Text(
                      cat.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 5),
                    cat.currentNum == cat.needNum
                        ? const Text(
                            '마감',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(ButtonColors.gray6),
                            ),
                          )
                        : Row(
                            children: [
                              Text(
                                '현원 ${cat.currentNum}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(ButtonColors.gray6),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '총원 ${cat.needNum}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(ButtonColors.gray6),
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => teamApply(widget.category[index].id),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(ButtonColors.indigo4),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                  child: const Text('지원'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
