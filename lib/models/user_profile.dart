import 'dart:convert';

import 'package:get/get.dart';

class UserProfile {
  final int userId;
  final String avatarUrl;
  final String nickname;
  final bool defaultAvatar;
  late RxBool followed;
  final int gender;
  final int birthday;
  final String description;
  final String backgroundUrl;
  final int province;
  final int city;
  final int userType;
  final int vipType;
  final int playlistCount;
  final int playlistBeSubscribedCount;
  final int allSubscribedCount;
  final int newFollows;
  final int follows;
  final int followeds;

  UserProfile({
    required this.userId,
    required this.avatarUrl,
    required this.nickname,
    required this.defaultAvatar,
    required bool followed,
    required this.gender,
    required this.birthday,
    required this.description,
    required this.backgroundUrl,
    required this.province,
    required this.city,
    required this.userType,
    required this.vipType,
    this.playlistCount = 0,
    this.playlistBeSubscribedCount = 0,
    this.allSubscribedCount = 0,
    this.newFollows = 0,
    this.follows = 0,
    this.followeds = 0,
  }) {
    this.followed = followed.obs;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'avatarUrl': avatarUrl,
      'nickname': nickname,
      'defaultAvatar': defaultAvatar,
      'followed': followed.value,
      'gender': gender,
      'birthday': birthday,
      'description': description,
      'backgroundUrl': backgroundUrl,
      'province': province,
      'city': city,
      'userType': userType,
      'vipType': vipType,
      'playlistCount': playlistCount,
      'playlistBeSubscribedCount': playlistBeSubscribedCount,
      'allSubscribedCount': allSubscribedCount,
      'newFollows': newFollows,
      'follows': follows,
      'followeds': followeds,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      userId: map['userId'] as int,
      avatarUrl: map['avatarUrl'] as String,
      nickname: map['nickname'] as String,
      defaultAvatar: (map['defaultAvatar'] as bool?) ?? false,
      followed: (map['followed'] as bool?) ?? false,
      gender: (map['gender'] as int?) ?? 0,
      birthday: (map['birthday'] as int?) ?? 0,
      description: (map['description'] as String?) ?? "",
      backgroundUrl: (map['backgroundUrl'] as String?) ?? "",
      province: (map['province'] as int?) ?? 0,
      city: (map['city'] as int?) ?? 0,
      userType: (map['userType'] as int?) ?? 0,
      vipType: (map['vipType'] as int?) ?? 0,
      playlistCount: (map['playlistCount'] as int?) ?? 0,
      playlistBeSubscribedCount:
          (map['playlistBeSubscribedCount'] as int?) ?? 0,
      allSubscribedCount: (map['allSubscribedCount'] as int?) ?? 0,
      newFollows: (map['newFollows'] as int?) ?? 0,
      follows: (map['follows'] as int?) ?? 0,
      followeds: (map['followeds'] as int?) ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source) as Map<String, dynamic>);
}
