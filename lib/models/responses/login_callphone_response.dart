import 'dart:convert';

import 'package:qianshi_music/models/login_account.dart';
import 'package:qianshi_music/models/login_profile.dart';

class LoginCallphoneResponse {
  final int code;
  int? loginType;
  LoginAccount? account;
  String? token;
  LoginProfile? profile;
  String? cookie;
  LoginCallphoneResponse({
    required this.code,
    this.loginType,
    this.account,
    this.token,
    this.profile,
    this.cookie,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'loginType': loginType,
      'account': account?.toMap(),
      'token': token,
      'profile': profile?.toMap(),
      'cookie': cookie,
    };
  }

  factory LoginCallphoneResponse.fromMap(Map<String, dynamic> map) {
    return LoginCallphoneResponse(
      code: map['code'] as int,
      loginType: map['loginType'] != null ? map['loginType'] as int : null,
      account: map['account'] != null
          ? LoginAccount.fromMap(map['account'] as Map<String, dynamic>)
          : null,
      token: map['token'] != null ? map['token'] as String : null,
      profile: map['profile'] != null
          ? LoginProfile.fromMap(map['profile'] as Map<String, dynamic>)
          : null,
      cookie: map['cookie'] != null ? map['cookie'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginCallphoneResponse.fromJson(String source) =>
      LoginCallphoneResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
