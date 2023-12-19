// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/track.dart';

class RecommendSongsDislikeResponse extends BaseResponse {
  final Track? data;
  RecommendSongsDislikeResponse({
    required super.code,
    this.data,
    super.msg,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll(<String, dynamic>{
        'data': data?.toMap(),
      });
  }

  factory RecommendSongsDislikeResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return RecommendSongsDislikeResponse(
      code: base.code,
      msg: base.msg,
      data: map['data'] != null
          ? Track.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory RecommendSongsDislikeResponse.fromJson(String source) =>
      RecommendSongsDislikeResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
