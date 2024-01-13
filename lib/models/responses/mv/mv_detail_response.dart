import 'dart:convert';

import 'package:qianshi_music/models/mv.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class MvDetailResponse extends BaseResponse {
  final Mv? data;
  MvDetailResponse({
    required super.code,
    super.msg,
    this.data,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'data': data?.toMap(),
      });
  }

  factory MvDetailResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return MvDetailResponse(
      code: base.code,
      msg: base.msg,
      data: map['data'] != null
          ? Mv.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory MvDetailResponse.fromJson(String source) =>
      MvDetailResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
