// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'package:qianshi_music/models/responses/base_response.dart';

class LikelistResponse extends BaseResponse {
  final int checkPoint;
  final List<int> ids;
  LikelistResponse({
    required super.code,
    super.msg,
    this.checkPoint = 0,
    this.ids = const [],
  });
  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'checkPoint': checkPoint,
        'ids': ids,
      });
  }

  factory LikelistResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return LikelistResponse(
      code: base.code,
      msg: base.msg,
      checkPoint: (map['checkPoint'] as int?) ?? 0,
      ids: map['ids'] == null ? [] : List<int>.from((map['ids'] as List<int>)),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory LikelistResponse.fromJson(String source) =>
      LikelistResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
