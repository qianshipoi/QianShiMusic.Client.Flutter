import 'dart:convert';

import 'package:qianshi_music/models/login_account.dart';
import 'package:qianshi_music/models/login_profile.dart';

class UserAccountResponse {
  final int code;
  final String? msg;
  LoginAccount? account;
  LoginProfile? profile;
  UserAccountResponse({
    required this.code,
    this.msg,
    this.account,
    this.profile,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'account': account?.toMap(),
      'profile': profile?.toMap(),
    };
  }

  factory UserAccountResponse.fromMap(Map<String, dynamic> map) {
    return UserAccountResponse(
      code: map['code'] as int,
      account: map['account'] != null
          ? LoginAccount.fromMap(map['account'] as Map<String, dynamic>)
          : null,
      profile: map['profile'] != null
          ? LoginProfile.fromMap(map['profile'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAccountResponse.fromJson(String source) =>
      UserAccountResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
