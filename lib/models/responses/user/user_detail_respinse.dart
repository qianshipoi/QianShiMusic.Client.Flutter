import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/user_profile.dart';

class UserDetailRespinse extends BaseResponse {
  final int level;
  final int listenSongs;
  final UserProfile? profile;
  final int createDays;
  final int createTime;

  UserDetailRespinse({
    required super.code,
    super.msg,
    this.level = 0,
    this.listenSongs = 0,
    this.profile,
    this.createDays = 0,
    this.createTime = 0,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'level': level,
        'listenSongs': listenSongs,
        'profile': profile?.toMap(),
        'createDays': createDays,
        'createTime': createTime,
      });
  }

  factory UserDetailRespinse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return UserDetailRespinse(
      code: base.code,
      msg: base.msg,
      level: (map['level'] as int?) ?? 0,
      listenSongs: (map['listenSongs'] as int?) ?? 0,
      profile: map['profile'] != null
          ? UserProfile.fromMap(map['profile'] as Map<String, dynamic>)
          : null,
      createDays: (map['createDays'] as int?) ?? 0,
      createTime: (map['createTime'] as int?) ?? 0,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory UserDetailRespinse.fromJson(String source) =>
      UserDetailRespinse.fromMap(json.decode(source) as Map<String, dynamic>);
}
