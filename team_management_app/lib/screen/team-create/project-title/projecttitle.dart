import 'package:flutter/material.dart';

class ProjectTitle extends StatefulWidget {
  const ProjectTitle({super.key});

  @override
  State<ProjectTitle> createState() => _ProjectTitleState();
}

class _ProjectTitleState extends State<ProjectTitle> {
  TextEditingController projecttitle = TextEditingController(); // 프로젝트 명*
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '프로젝트 명 *',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 50,
          child: TextField(
            controller: projecttitle,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
