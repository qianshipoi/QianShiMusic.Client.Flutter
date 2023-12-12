import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';

class LoginAnonimousResponse extends BaseResponse {
  final String cookie;
  LoginAnonimousResponse({
    required super.code,
    this.cookie = "",
    super.msg,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'cookie': cookie,
      });
  }

  factory LoginAnonimousResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);

    return LoginAnonimousResponse(
      code: base.code,
      cookie: map['cookie'] != null ? map['cookie'] as String : "",
      msg: base.msg,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory LoginAnonimousResponse.fromJson(String source) =>
      LoginAnonimousResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
