class User {
  final String name;
  final String studentNum;
  final int id;

  User({
    required this.name,
    required this.studentNum,
    required this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? 'Unknown', // 기본값 제공
      studentNum: json['student_num'] ?? 'No Number', // 기본값 제공
      id: json['id'] ?? 0, // 기본값 제공
    );
  }
}
