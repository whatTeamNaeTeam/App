import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:team_management_app/model/user.dart';
import 'package:team_management_app/assets/color/colors.dart';
import 'package:team_management_app/screen/entireappbar.dart';
import '../../api_service/api_service.dart';

class UserListWidget extends StatefulWidget {
  const UserListWidget({super.key});

  @override
  UserListWidgetState createState() => UserListWidgetState();
}

class UserListWidgetState extends State<UserListWidget> {
  bool isLoading = true;
  List<User> unapprovedUsers = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void loadUsers() async {
    setState(() => isLoading = true);
    await ApiService.instance.getUsers();
    unapprovedUsers = ApiService.users;
    setState(() => isLoading = false);
  }

  void approveUser(int userId) async {
    await ApiService.instance.approveUsers(userId);
    loadUsers(); // 승인 후 사용자 목록을 다시 불러옴
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Loading Users...")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: const EntireAppbar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/waiting.svg',
                    width: 24, height: 24),
                const SizedBox(width: 10),
                Text(
                  "승인 대기중(${unapprovedUsers.length})",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: unapprovedUsers.isEmpty
                  ? const Center(child: Text("No unapproved users found."))
                  : ListView.builder(
                      itemCount: unapprovedUsers.length,
                      itemBuilder: (context, index) {
                        User user = unapprovedUsers[index];
                        return ListTile(
                          title: Text(
                            user.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(user.studentNum),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      Color(ButtonColors.indigo4color),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => approveUser(user.id),
                                child: const Text("승인",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      Color(ButtonColors.red7color),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () {
                                  // 거절 로직 구현
                                },
                                child: const Text("거절",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
