import 'dart:convert';

class BaseResponse {
  final int code;
  final String? msg;
  BaseResponse({
    required this.code,
    this.msg,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'msg': msg,
    };
  }

  factory BaseResponse.fromMap(Map<String, dynamic> map) {
    return BaseResponse(
      code: map['code'] as int,
      msg: map['msg'] != null ? map['msg'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BaseResponse.fromJson(String source) =>
      BaseResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
