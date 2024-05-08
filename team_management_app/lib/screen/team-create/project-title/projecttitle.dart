import 'package:flutter/material.dart';

class ProjectTitle extends StatefulWidget {
  final TextEditingController initialprojectTitleController; // 프로젝트 명*
  const ProjectTitle({super.key, required this.initialprojectTitleController});

  @override
  State<ProjectTitle> createState() => _ProjectTitleState();
}

class _ProjectTitleState extends State<ProjectTitle> {
  TextEditingController? _projectTitleController; // 프로젝트 명*

  @override
  void initState() {
    super.initState();
    _projectTitleController = widget.initialprojectTitleController;
  }

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
            controller: _projectTitleController,
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
