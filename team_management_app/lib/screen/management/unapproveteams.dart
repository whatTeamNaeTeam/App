import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:team_management_app/api_service/api_service.dart';
import 'package:team_management_app/model/team.dart';
import 'package:team_management_app/assets/color/colors.dart';
import 'package:team_management_app/screen/entireappbar.dart';

class UnApproveTeams extends StatefulWidget {
  const UnApproveTeams({super.key});

  @override
  State<UnApproveTeams> createState() => _UnApproveTeamsState();
}

class _UnApproveTeamsState extends State<UnApproveTeams> {
  bool isLoading = true;
  List<UnapproveTeam> unapproveTeams = [];

  @override
  void initState() {
    super.initState();
    loadTeams();
  }

  void loadTeams() async {
    setState(() => isLoading = true);
    await ApiService.instance.getunApproveTeams(unapproveTeams);
    setState(() => isLoading = false);
  }

  void approveTeam(int teamid) async {
    await ApiService.instance.approveTeams(teamid);
    loadTeams();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Loading Teams...")),
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
                  "승인 대기중(${unapproveTeams.length})",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: unapproveTeams.isEmpty
                  ? const Center(child: Text("No unapproved Teams found."))
                  : ListView.builder(
                      itemCount: unapproveTeams.length,
                      itemBuilder: (context, index) {
                        UnapproveTeam unTeam = unapproveTeams[index];
                        return ListTile(
                          title: Text(
                            unTeam.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("${unTeam.id}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      const Color(ButtonColors.indigo4),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => approveTeam(unTeam.id),
                                child: const Text("승인",
                                    style: TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      const Color(ButtonColors.red7),
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
