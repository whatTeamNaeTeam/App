// ignore_for_file: public_member_api_docs, sort_constructors_first
class UnapproveTeam {
  final int id;
  final String name;
  final String createdat;
  UnapproveTeam({
    required this.id,
    required this.name,
    required this.createdat,
  });

  factory UnapproveTeam.fromJson(Map<String, dynamic> json) {
    return UnapproveTeam(
      id: json['id'] ?? 'Unknown', // 기본값 제공
      name: json['name'] ?? 'No Number', // 기본값 제공
      createdat: json['created_at'] ?? 0, // 기본값 제공
    );
  }
}
