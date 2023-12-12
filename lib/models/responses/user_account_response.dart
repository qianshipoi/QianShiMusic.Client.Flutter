import 'dart:convert';

import 'package:qianshi_music/models/login_account.dart';
import 'package:qianshi_music/models/login_profile.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class UserAccountResponse extends BaseResponse {
  LoginAccount? account;
  LoginProfile? profile;
  UserAccountResponse({
    required super.code,
    super.msg,
    this.account,
    this.profile,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'account': account?.toMap(),
        'profile': profile?.toMap(),
      });
  }

  factory UserAccountResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return UserAccountResponse(
      code: base.code,
      msg: base.msg,
      account: map['account'] != null
          ? LoginAccount.fromMap(map['account'] as Map<String, dynamic>)
          : null,
      profile: map['profile'] != null
          ? LoginProfile.fromMap(map['profile'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory UserAccountResponse.fromJson(String source) =>
      UserAccountResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
