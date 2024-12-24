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
      imageUrl: json['image_url'] ?? '',
    );
  }
}

class Team {
  final int id;
  final String title;
  final String? explain;
  final List<String>? imageUrl;
  final List<Category> category;
  final LeaderInfo leaderInfo;
  final int like;
  final int version;
  final int view;
  final String genre;
  final List<String> urls;
  final bool isLike;
  final bool isApproved;

  Team({
    required this.id,
    required this.leaderInfo,
    required this.title,
    this.explain,
    required this.genre,
    required this.like,
    required this.version,
    this.imageUrl,
    required this.view,
    required this.category,
    required this.urls,
    required this.isLike,
    required this.isApproved,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    var categoryJson = json['category'] as List? ?? [];
    List<Category> categoryList =
        categoryJson.map((i) => Category.fromJson(i)).toList();

    // image_url이 문자열이거나 리스트로 제공될 수 있기 때문에 유연하게 처리
    List<String>? imageUrlList;
    if (json['image_url'] is List) {
      // 리스트일 경우 그대로 처리
      imageUrlList = List<String>.from(json['image_url']);
    } else if (json['image_url'] is String) {
      // 문자열일 경우 이를 리스트로 변환
      imageUrlList = [json['image_url']];
    }

    return Team(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      explain: json['explain'] ?? '',
      imageUrl: imageUrlList, // 위에서 처리된 imageUrlList 사용
      category: categoryList,
      leaderInfo: LeaderInfo.fromJson(json['leader_info'] ?? {}),
      like: json['like'] ?? 0,
      version: json['version'] ?? 0,
      view: int.tryParse(json['view']?.toString() ?? '0') ?? 0,
      genre: json['genre'] ?? '',
      urls: List<String>.from(json['urls'] ?? []),
      isLike: json['is_like'] ?? false,
      isApproved: json['is_approved'] ?? false,
    );
  }
}

class ApiResponse {
  final Team team;
  final bool? isLeader;

  ApiResponse({
    required this.team,
    required this.isLeader,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      team: Team.fromJson(json['team'] ?? {}),
      isLeader: json['is_leader'] ?? false,
    );
  }
}
