import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImageFromGallery() async {
  final ImagePicker picker = ImagePicker();

  // 갤러리에서 이미지를 선택합니다.
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  // 사용자가 이미지를 선택하면, 이미지 파일 객체를 반환합니다.
  if (image != null) {
    return File(image.path);
  } else {
    // 사용자가 이미지 선택을 취소한 경우
    return null;
  }
}
