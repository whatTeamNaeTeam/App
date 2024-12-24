class UserProfile {
  final Profile profile;
  final List<Url> url;
  final List<Tech> tech;
  final bool isOwner;

  UserProfile({
    required this.profile,
    required this.url,
    required this.tech,
    required this.isOwner,
  });

  // 수동으로 JSON 데이터를 Dart 객체로 변환
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      profile: Profile.fromJson(json['profile']),
      url: (json['url'] as List).map((item) => Url.fromJson(item)).toList(),
      tech: (json['tech'] as List).map((item) => Tech.fromJson(item)).toList(),
      isOwner: json['is_owner'] as bool,
    );
  }

  // 수동으로 Dart 객체를 JSON 데이터로 변환
  Map<String, dynamic> toJson() {
    return {
      'profile': profile.toJson(),
      'url': url.map((item) => item.toJson()).toList(),
      'tech': tech.map((item) => item.toJson()).toList(),
      'is_owner': isOwner,
    };
  }
}

class Profile {
  final String name;
  final String studentNum;
  final int id;
  final String imageUrl;
  final bool isApproved;
  final bool isStaff;
  final String position;
  final String explain;

  Profile({
    required this.name,
    required this.studentNum,
    required this.id,
    required this.imageUrl,
    required this.isApproved,
    required this.isStaff,
    required this.position,
    required this.explain,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      studentNum: json['student_num'],
      id: json['id'],
      imageUrl: json['image_url'],
      isApproved: json['is_approved'],
      isStaff: json['is_staff'],
      position: json['position'],
      explain: json['explain'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'student_num': studentNum,
      'id': id,
      'image_url': imageUrl,
      'is_approved': isApproved,
      'is_staff': isStaff,
      'position': position,
      'explain': explain,
    };
  }
}

class Url {
  final String url;

  Url({required this.url});

  factory Url.fromJson(Map<String, dynamic> json) {
    return Url(
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}

class Tech {
  final String name;

  Tech({required this.name});

  factory Tech.fromJson(Map<String, dynamic> json) {
    return Tech(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
