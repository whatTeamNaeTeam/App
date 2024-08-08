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
      id: json['id'],
      title: json['tech'],
      needNum: json['need_num'],
      currentNum: json['current_num'],
    );
  }
}

class LeaderInfo {
  final int id;
  final String name;
  final String imageUrl;

  LeaderInfo({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory LeaderInfo.fromJson(Map<String, dynamic> json) {
    return LeaderInfo(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
    );
  }
}

class Result {
  final int id;
  final String title;
  final String imageUrl;
  final List<Category> category;
  final LeaderInfo leaderInfo;
  final int like;
  final int version;
  final int view;
  final String genre;
  final bool isLike;

  Result({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.category,
    required this.leaderInfo,
    required this.like,
    required this.version,
    required this.view,
    required this.genre,
    required this.isLike,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    var categoryJson = json['category'] as List;
    List<Category> categoryList =
        categoryJson.map((i) => Category.fromJson(i)).toList();

    return Result(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image_url'],
      category: categoryList,
      leaderInfo: LeaderInfo.fromJson(json['leader_info']),
      like: json['like'],
      version: json['version'],
      view: json['view'],
      genre: json['genre'],
      isLike: json['is_like'],
    );
  }

  // copyWith 메서드 추가
  Result copyWith({
    int? id,
    String? title,
    String? imageUrl,
    List<Category>? category,
    LeaderInfo? leaderInfo,
    int? like,
    int? version,
    int? view,
    String? genre,
    bool? isLike,
  }) {
    return Result(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      leaderInfo: leaderInfo ?? this.leaderInfo,
      like: like ?? this.like,
      version: version ?? this.version,
      view: view ?? this.view,
      genre: genre ?? this.genre,
      isLike: isLike ?? this.isLike,
    );
  }
}

class ApiResponse {
  final String? next;
  final String? previous;
  final List<Result> results;

  ApiResponse({
    required this.next,
    required this.previous,
    required this.results,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var resultsJson = json['results'] as List;
    List<Result> resultsList =
        resultsJson.map((i) => Result.fromJson(i)).toList();

    return ApiResponse(
        next: json['next'], previous: json['previous'], results: resultsList);
  }
}
