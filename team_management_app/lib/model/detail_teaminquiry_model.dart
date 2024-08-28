// ignore_for_file: public_member_api_docs, sort_constructors_first
class Category {
  final int id;
  final String title;
  final int needNum;
  final int currentNum;

  Category({
    required this.id,
    required this.title,
    required this.needNum,
    required this.currentNum,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      title: json['tech'] ?? '',
      needNum: json['need_num'] ?? 0,
      currentNum: json['current_num'] ?? 0,
    );
  }
}

class LeaderInfo {
  final int id;
  final String name;
  final String? imageUrl;

  LeaderInfo({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory LeaderInfo.fromJson(Map<String, dynamic> json) {
    return LeaderInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['image_url'],
    );
  }
}

class Team {
  final int id;
  final String title;
  final String? explain;
  final String? imageUrl;
  final List<Category> category;
  final LeaderInfo leaderInfo;
  final int like;
  final int version;
  final int view;
  final String genre;
  final List<String> urls;

  Team({
    required this.id,
    required this.title,
    this.explain,
    this.imageUrl,
    required this.category,
    required this.leaderInfo,
    required this.like,
    required this.version,
    required this.view,
    required this.genre,
    required this.urls,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    var categoryJson = json['category'] as List? ?? [];
    List<Category> categoryList =
        categoryJson.map((i) => Category.fromJson(i)).toList();

    return Team(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      explain: json['explain'] ?? '', // explain 필드 추가
      imageUrl: json['image_url'],
      category: categoryList,
      leaderInfo: LeaderInfo.fromJson(json['leader_info'] ?? {}),
      like: json['like'] ?? 0,
      version: json['version'] ?? 0,
      view: json['view'] ?? 0,
      genre: json['genre'] ?? '',
      urls: List<String>.from(json['urls'] ?? []),
    );
  }

  Team copyWith({
    int? id,
    String? title,
    String? explain,
    String? imageUrl,
    List<Category>? category,
    LeaderInfo? leaderInfo,
    int? like,
    int? version,
    int? view,
    String? genre,
    List<String>? urls,
  }) {
    return Team(
      id: id ?? this.id,
      title: title ?? this.title,
      explain: explain ?? this.explain,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      leaderInfo: leaderInfo ?? this.leaderInfo,
      like: like ?? this.like,
      version: version ?? this.version,
      view: view ?? this.view,
      genre: genre ?? this.genre,
      urls: urls ?? this.urls,
    );
  }
}

class ApiResponse {
  final Team team;
  final bool? isLeader;
  final bool isLike;

  ApiResponse({
    required this.team,
    required this.isLeader,
    required this.isLike,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      team: Team.fromJson(json['team'] ?? {}),
      isLeader: json['is_leader'],
      isLike: json['is_like'],
    );
  }
}
