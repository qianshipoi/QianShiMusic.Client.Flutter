import 'dart:convert';

class LoginAnonimousResponse {
  final int code;
  final String? cookie;
  final String? msg;
  LoginAnonimousResponse({
    required this.code,
    this.cookie,
    this.msg,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'cookie': cookie,
      'msg': msg,
    };
  }

  factory LoginAnonimousResponse.fromMap(Map<String, dynamic> map) {
    return LoginAnonimousResponse(
      code: map['code'] as int,
      cookie: map['cookie'] != null ? map['cookie'] as String : null,
      msg: map['msg'] != null ? map['msg'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginAnonimousResponse.fromJson(String source) =>
      LoginAnonimousResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
