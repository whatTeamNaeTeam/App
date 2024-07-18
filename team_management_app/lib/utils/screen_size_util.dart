// lib/utils/screen_size_util.dart
import 'package:flutter/material.dart';

class ScreenSizeUtil {
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
