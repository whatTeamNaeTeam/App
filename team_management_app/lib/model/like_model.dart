class Like {
  final int likeCount;
  final bool isLike;

  Like({
    required this.likeCount,
    required this.isLike,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      likeCount: json['like_count'],
      isLike: json['is_like'],
    );
  }
}

class Islike {
  final Like like;
  final int version;

  Islike({
    required this.like,
    required this.version,
  });

  factory Islike.fromJson(Map<String, dynamic> json) {
    return Islike(
      like: Like.fromJson(json['like']),
      version: json['version'],
    );
  }
}
