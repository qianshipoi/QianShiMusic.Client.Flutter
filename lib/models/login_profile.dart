import 'dart:convert';

class LoginProfile {
  final int userId;
  String backgroundUrl;
  String avatarUrl;
  int userType;
  int vipType;
  int authStatus;
  int djStatus;
  String detailDescription;
  int accountStatus;
  String nickname;
  int birthday;
  int gender;
  int city;
  int province;
  bool defaultAvatar;
  String description;
  int followeds;
  int follows;
  int playlistCount;
  int playlistBeSubscribedCount;
  LoginProfile({
    required this.userId,
    required this.backgroundUrl,
    required this.avatarUrl,
    required this.userType,
    required this.vipType,
    required this.authStatus,
    required this.djStatus,
    required this.detailDescription,
    required this.accountStatus,
    required this.nickname,
    required this.birthday,
    required this.gender,
    required this.city,
    required this.province,
    required this.defaultAvatar,
    required this.description,
    required this.followeds,
    required this.follows,
    required this.playlistCount,
    required this.playlistBeSubscribedCount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'backgroundUrl': backgroundUrl,
      'avatarUrl': avatarUrl,
      'userType': userType,
      'vipType': vipType,
      'authStatus': authStatus,
      'djStatus': djStatus,
      'detailDescription': detailDescription,
      'accountStatus': accountStatus,
      'nickname': nickname,
      'birthday': birthday,
      'gender': gender,
      'city': city,
      'province': province,
      'defaultAvatar': defaultAvatar,
      'description': description,
      'followeds': followeds,
      'follows': follows,
      'playlistCount': playlistCount,
      'playlistBeSubscribedCount': playlistBeSubscribedCount,
    };
  }

  factory LoginProfile.fromMap(Map<String, dynamic> map) {
    return LoginProfile(
      userId: map['userId'] as int,
      backgroundUrl: map['backgroundUrl'] as String,
      avatarUrl: map['avatarUrl'] as String,
      userType: map['userType'] as int,
      vipType: map['vipType'] as int,
      authStatus: map['authStatus'] as int,
      djStatus: map['djStatus'] as int,
      detailDescription: map['detailDescription'] as String,
      accountStatus: map['accountStatus'] as int,
      nickname: map['nickname'] as String,
      birthday: map['birthday'] as int,
      gender: map['gender'] as int,
      city: map['city'] as int,
      province: map['province'] as int,
      defaultAvatar: map['defaultAvatar'] as bool,
      description: map['description'] as String,
      followeds: map['followeds'] as int,
      follows: map['follows'] as int,
      playlistCount: map['playlistCount'] as int,
      playlistBeSubscribedCount: map['playlistBeSubscribedCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginProfile.fromJson(String source) =>
      LoginProfile.fromMap(json.decode(source) as Map<String, dynamic>);
}
