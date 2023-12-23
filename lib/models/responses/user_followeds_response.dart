import 'dart:convert';
import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/user_profile.dart';

class UserFollowedsResponse extends BaseResponse {
  final int size;
  final List<UserProfile> followeds;
  final bool more;
  UserFollowedsResponse({
    required super.code,
    super.msg,
    this.size = 0,
    this.followeds = const [],
    this.more = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'size': size,
        'followeds': followeds.map((x) => x.toMap()).toList(),
        'more': more,
      });
  }

  factory UserFollowedsResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return UserFollowedsResponse(
      code: base.code,
      msg: base.msg,
      size: (map['size'] as int?) ?? 0,
      followeds: map['followeds'] == null
          ? []
          : List<UserProfile>.from(
              (map['followeds'] as List<dynamic>).map<UserProfile>(
                (x) => UserProfile.fromMap(x as Map<String, dynamic>),
              ),
            ),
      more: (map['more'] as bool?) ?? false,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory UserFollowedsResponse.fromJson(String source) =>
      UserFollowedsResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
