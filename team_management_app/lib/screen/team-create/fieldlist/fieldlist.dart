import 'package:flutter/material.dart';
import 'package:list_picker/list_picker.dart';
import 'package:team_management_app/screen/colors.dart';

class FieldList extends StatefulWidget {
  const FieldList({super.key});

  @override
  State<FieldList> createState() => _FieldListState();
}

class _FieldListState extends State<FieldList> {
  List<ListPickerField> fields = [];

  final listPickerField = ListPickerField(
    label: "전공 분야 선택",
    items: const ["프론트 엔드", "백엔드", "UI/UX", "PM"],
  );

// listPickerField add 함수
  void addListItem() {
    setState(() {
      fields.add(listPickerField);
    });
  }

  void removeListItem(int index) {
    setState(() {
      fields.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    int peopleCount = fields.length; // 인원 수 세리기
    var containerwidth = MediaQuery.of(context).size.width * 0.8;
    return Column(
      children: [
        Row(
          children: [
            Text(
              '모집 인원($peopleCount) *',
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
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
              onPressed: addListItem,
              child: const Text("추가",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: fields.length,
          itemBuilder: (context, index) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: containerwidth,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: fields[index],
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.remove_circle,
                    color: Color(ButtonColors.red7color),
                    size: 24,
                  ),
                  onPressed: () => removeListItem(index),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
