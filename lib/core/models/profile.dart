import 'package:redesigned/core/models/person.dart';

class Profile extends Person {
  String bio;
  bool isProfilePrivate;
  bool isFollowing;
  String pronouns;
  List<String> followerIDs;
  List<String> followingIDs;
  List<String> postIDs;

  Profile({
    required super.id,
    required super.userName,
    required super.name,
    required super.profilePicturePath,
    this.bio = '',
    this.isProfilePrivate = false,
    this.isFollowing = false,
    this.pronouns = '',
    this.followerIDs = const [],
    this.followingIDs = const [],
    this.postIDs = const [],
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      userName: json['userName'] as String,
      name: json['name'] as String,
      profilePicturePath: json['profilePicturePath'] as String,
      bio: json['bio'] as String? ?? '',
      isProfilePrivate: json['isProfilePrivate'] as bool? ?? false,
      isFollowing: json['isFollowing'] as bool? ?? false,
      pronouns: json['pronouns'] as String? ?? '',
      followerIDs: List<String>.from(json['followerIDs'] ?? []),
      followingIDs: List<String>.from(json['followingIDs'] ?? []),
      postIDs: List<String>.from(json['postIDs'] ?? []),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    data.addAll({
      'bio': bio,
      'isProfilePrivate': isProfilePrivate,
      'isFollowing': isFollowing,
      'pronouns': pronouns,
      'followerIDs': followerIDs,
      'followingIDs': followingIDs,
      'postIDs': postIDs,
    });
    return data;
  }
}
