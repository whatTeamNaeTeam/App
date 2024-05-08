import 'package:flutter/material.dart';
import 'package:list_picker/list_picker.dart'; // 이 패키지는 가정하에 사용합니다.
import 'package:team_management_app/screen/colors.dart';

class FieldList extends StatefulWidget {
  final List<TextEditingController> initialcontrollers;
  const FieldList({super.key, required this.initialcontrollers});

  @override
  State<FieldList> createState() => _FieldListState();
}

class _FieldListState extends State<FieldList> {
  final List<String> majorFields = ['프론트 엔드', '백엔드', '기획', '게임', 'AI', '디자인'];
  final Map<String, List<String>> subFieldsMap = {
    '프론트 엔드': ['웹', 'iOS', '안드로이드', '크로스플랫폼'],
    '백엔드': ['자바', '파이썬', '노드'],
    '기획': ['UI/UX 기획', '게임 기획', '컨텐츠 기획', '프로젝트 매니저'],
    '게임': ['유니티', '언리얼'],
    'AI': ['딥러닝', '머신러닝', '데이터 엔지니어'],
    '디자인': ['게임 그래픽 디자인', 'UI/UX 디자인']
  };

  List<TextEditingController> controllers = [];
  List<TextEditingController> subcontrollers = [];
  List<Widget> majorFieldsWidgets = [];
  List<Widget> subFieldsWidgets = [];

  @override
  void initState() {
    super.initState();
    subcontrollers = widget.initialcontrollers; // 부모로부터 초기 컨트롤러 리스트를 받습니다.
  }

  void addListItem() {
    TextEditingController controller = TextEditingController();
    controllers.add(controller);
    controller.addListener(() {
      updateSubFields(controllers.indexOf(controller), controller.text);
    });

    setState(() {
      majorFieldsWidgets.add(ListPickerField(
        width: MediaQuery.of(context).size.width * 0.7,
        label: "분야 선택",
        items: majorFields,
        controller: controller,
      ));
      subFieldsWidgets.add(Container()); // 초기에는 비어있는 컨테이너 추가
    });
  }

  void updateSubFields(int index, String selectedMajorField) {
    List<String>? subFields = subFieldsMap[selectedMajorField];
    if (subFields != null) {
      TextEditingController subController = TextEditingController();
      subcontrollers.add(subController); // 새 컨트롤러를 리스트에 추가
      setState(() {
        subFieldsWidgets[index] = ListPickerField(
          width: MediaQuery.of(context).size.width * 0.7,
          label: "서브 분야 선택",
          items: subFields,
          controller: subController,
        );
      });
    }
  }

  void removeListItem(int index) {
    if (index < controllers.length) {
      // 주 컨트롤러 제거
      controllers[index].dispose();
      controllers.removeAt(index);
      majorFieldsWidgets.removeAt(index);
      subFieldsWidgets.removeAt(index);

      // 서브 컨트롤러가 존재하는지 확인하고 제거
      if (index < subcontrollers.length) {
        subcontrollers[index].dispose();
        subcontrollers.removeAt(index);
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '모집 인원(${majorFieldsWidgets.length}) *',
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
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
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: majorFieldsWidgets.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      majorFieldsWidgets[index],
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removeListItem(index),
                      ),
                    ],
                  ),
                  subFieldsWidgets[index],
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
