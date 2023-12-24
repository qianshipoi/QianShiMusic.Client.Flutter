import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/user_profile.dart';

class UserFollowsResponse extends BaseResponse {
  final int touchCount;
  final List<UserProfile> follow;
  final bool more;
  UserFollowsResponse({
    required super.code,
    super.msg,
    this.touchCount = 0,
    this.follow = const [],
    this.more = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'touchCount': touchCount,
        'follow': follow.map((x) => x.toMap()).toList(),
        'more': more,
      });
  }

  factory UserFollowsResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return UserFollowsResponse(
      code: base.code,
      msg: base.msg,
      touchCount: (map['touchCount'] as int?) ?? 0,
      follow: map['follow'] == null
          ? []
          : List<UserProfile>.from(
              (map['follow'] as List<dynamic>).map<UserProfile>(
                (x) => UserProfile.fromMap(x as Map<String, dynamic>),
              ),
            ),
      more: (map['more'] as bool?) ?? false,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory UserFollowsResponse.fromJson(String source) =>
      UserFollowsResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
