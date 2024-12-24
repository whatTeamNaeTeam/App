import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:team_management_app/assets/color/colors.dart';
import 'package:team_management_app/model/userprofilemodel.dart';
import 'package:team_management_app/screen/MyPage/mypageurl.dart';

class MyPage extends StatefulWidget {
  final UserProfile userProfile;
  const MyPage({super.key, required this.userProfile});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late String imageUrl;
  late String name;
  late String position;
  late List<Tech>? tech;
  late String explain;
  late List<Url> urls;
  late bool isStaff;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.userProfile.profile.imageUrl;
    name = widget.userProfile.profile.name;
    position = widget.userProfile.profile.position;
    tech = widget.userProfile.tech;
    explain = widget.userProfile.profile.explain;
    isStaff = widget.userProfile.profile.isStaff;

    // 목업 데이터를 사용하여 url 리스트 초기화
    urls = [
      Url(url: "https://github.com"),
      Url(url: "https://test.com"),
      Url(url: "https://1234.com"),
      Url(url: "https://567.com"),
      Url(url: "https://567333333333333333333333234sdfsdf.com"),
    ];

    tech = [
      Tech(name: 'Flutter'),
      Tech(name: 'Dart'),
      Tech(name: 'Firebase'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.network(
                    imageUrl,
                    width: 50,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () => log('수정 버튼이 눌림'),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                              decoration: BoxDecoration(
                                  color: const Color(ButtonColors.indigo4),
                                  borderRadius: BorderRadius.circular(6)),
                              child: const Text(
                                '수정',
                                style: TextStyle(
                                  color: Color(ButtonColors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Text(
                        position,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      tech == null || tech!.isEmpty
                          ? IntrinsicWidth(
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                                decoration: BoxDecoration(
                                  color: const Color(ButtonColors.gray4),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Center(
                                  child: Text(
                                    'none',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                            )
                          : Row(
                              children: tech!.map((techItem) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 2, 5, 2),
                                    decoration: BoxDecoration(
                                      color: const Color(ButtonColors.gray4),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      techItem.name,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              explain,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              '링크',
              style: TextStyle(
                fontSize: 18,
                color: Color(ButtonColors.gray6),
              ),
            ),
            urls.isEmpty
                ? const Text('등록된 url이 없습니다.')
                : MyPageUrls(urls: urls),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () => log('내 활동 내역 버튼 눌림'),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/my_activity.png',
                    width: 24,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    '내 활동',
                    style: TextStyle(fontSize: 21),
                  ),
                ],
              ),
            ),
            const Divider(),
            InkWell(
              onTap: () => log('내 활동 내역 버튼 눌림'),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/team_management.png',
                    width: 24,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    '팀 관리',
                    style: TextStyle(fontSize: 21),
                  ),
                ],
              ),
            ),
            const Divider()
          ],
        ),
      ),
    );
  }
}
