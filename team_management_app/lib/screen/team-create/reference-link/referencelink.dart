import 'package:flutter/material.dart';
import 'package:team_management_app/screen/colors.dart';

class ReferenceLink extends StatefulWidget {
  const ReferenceLink({super.key});

  @override
  State<ReferenceLink> createState() => _ReferenceLinkState();
}

class _ReferenceLinkState extends State<ReferenceLink> {
  List<TextEditingController> controllers = [];

  void addTextField() {
    setState(() {
      controllers.add(TextEditingController());
    });
  }

  void removeTextField(int index) {
    setState(() {
      controllers[index].dispose(); // 메모리 누수 방지
      controllers.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "관련 링크",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(ButtonColors.indigo4color),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: addTextField,
              child: const Text("추가",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: controllers.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: TextField(
                controller: controllers[index],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0.5,
                    ),
                  ),
                  label: Text("https://github.com"),
                ),
              ),
              trailing: SizedBox(
                width: 20,
                child: IconButton(
                  icon: Icon(
                    Icons.remove_circle,
                    color: Color(ButtonColors.red7color),
                    size: 24,
                  ),
                  onPressed: () => removeTextField(index),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
