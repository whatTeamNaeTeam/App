import 'dart:io';

class Team {
  String? title;
  String? explain;
  String? genre;
  File? image;
  List<String>? urls;
  List<String>? subCategory;
  List<String>? memberCount;

  Team({
    required this.title,
    required this.explain,
    required this.genre,
    required this.image,
    required this.urls,
    required this.subCategory,
    required this.memberCount,
  });
}
