// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:team_management_app/api_service/api_service.dart';

import 'package:team_management_app/assets/color/colors.dart';
import 'package:team_management_app/model/detail_teaminquiry_model.dart';
import 'package:team_management_app/utils/discription_dialog.dart';

class ApplyContainerGrid extends StatefulWidget {
  final List<Category> category;
  const ApplyContainerGrid({
    super.key,
    required this.category,
  });

  @override
  State<ApplyContainerGrid> createState() => _ApplyContainerGridState();
}

class _ApplyContainerGridState extends State<ApplyContainerGrid> {
  Future<void> teamApply(int categoryid) async {
    log('지원하기 버튼이 눌렸음');
    showDialog(
      context: context,
      builder: (context) => DialogUI(
        title: '지원하기',
        discription: '각오 한마디!',
        onPressed: (String bio) async {
          // 다이얼로그에서 bio 값을 받음
          bool success = await ApiService.instance.teamapply(bio, categoryid);
          if (success) {
            log('팀 지원이 성공적으로 완료되었습니다.');
          } else {
            log('팀 지원에 실패했습니다.');
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80 *
          (widget.category.length / 2)
              .ceil()
              .toDouble(), // ceil을 통해서 반올림 후 계산 (1.5 나올 시 반올림)
      // 아래에 하나의 텍스트 추가 시 100으로 설정하면 됩니다.
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 0.5,
            color: const Color(ButtonColors.gray4),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // GridView의 스크롤 비활성화
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 가로로 2개의 아이템씩 배치
            crossAxisSpacing: 5, // 아이템 사이의 가로 간격
            // mainAxisSpacing: 10, // 아이템 사이의 세로 간격
            // childAspectRatio: 1.8, // 아이템의 가로 세로 비율
          ),
          itemCount: widget.category.length,
          itemBuilder: (context, index) {
            final cat = widget.category[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cat.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color(
                        ButtonColors.indigo4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  cat.currentNum == cat.needNum
                      ? const Text(
                          '마감',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(ButtonColors.gray6),
                          ),
                        )
                      : Row(
                          children: [
                            Text(
                              '현원 ${cat.currentNum}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(ButtonColors.gray6),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '총원 ${cat.needNum}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(ButtonColors.gray6),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
