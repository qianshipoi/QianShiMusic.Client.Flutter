import 'dart:convert';

import 'package:qianshi_music/models/login_account.dart';
import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/user_profile.dart';

class LoginCallphoneResponse extends BaseResponse {
  final int? loginType;
  final LoginAccount? account;
  final String? token;
  final UserProfile? profile;
  final String? cookie;
  LoginCallphoneResponse({
    required super.code,
    super.msg,
    this.loginType,
    this.account,
    this.token,
    this.profile,
    this.cookie,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'loginType': loginType,
        'account': account?.toMap(),
        'token': token,
        'profile': profile?.toMap(),
        'cookie': cookie,
      });
  }

  factory LoginCallphoneResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return LoginCallphoneResponse(
      code: base.code,
      msg: base.msg,
      loginType: map['loginType'] != null ? map['loginType'] as int : null,
      account: map['account'] != null
          ? LoginAccount.fromMap(map['account'] as Map<String, dynamic>)
          : null,
      token: map['token'] != null ? map['token'] as String : null,
      profile: map['profile'] != null
          ? UserProfile.fromMap(map['profile'] as Map<String, dynamic>)
          : null,
      cookie: map['cookie'] != null ? map['cookie'] as String : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory LoginCallphoneResponse.fromJson(String source) =>
      LoginCallphoneResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
