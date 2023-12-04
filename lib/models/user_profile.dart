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
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      userId: map['userId'] as int,
      avatarUrl: map['avatarUrl'] as String,
      nickname: map['nickname'] as String,
      defaultAvatar: map['defaultAvatar'] as bool,
      followed: map['followed'] as bool,
      gender: map['gender'] as int,
      birthday: map['birthday'] as int,
      description: map['description'] as String,
      backgroundUrl: map['backgroundUrl'] as String,
      province: map['province'] as int,
      city: map['city'] as int,
      userType: map['userType'] as int,
      vipType: map['vipType'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(json.decode(source) as Map<String, dynamic>);
}
