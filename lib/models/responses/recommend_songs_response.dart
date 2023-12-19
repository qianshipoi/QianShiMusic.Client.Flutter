// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/track.dart';

class RecommendSongsResponse extends BaseResponse {
  final RecommendSongsResponseData? data;

  RecommendSongsResponse({
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

  factory RecommendSongsResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return RecommendSongsResponse(
      code: base.code,
      msg: base.msg,
      data: map['data'] != null
          ? RecommendSongsResponseData.fromMap(
              map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory RecommendSongsResponse.fromJson(String source) =>
      RecommendSongsResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class RecommendSongsResponseData {
  final List<Track> dailySongs;
  final List<RecommendReason> recommend;
  RecommendSongsResponseData({
    required this.dailySongs,
    required this.recommend,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dailySongs': dailySongs.map((x) => x.toMap()).toList(),
      'recommend': recommend.map((x) => x.toMap()).toList(),
    };
  }

  factory RecommendSongsResponseData.fromMap(Map<String, dynamic> map) {
    return RecommendSongsResponseData(
      dailySongs: map['dailySongs'] == null
          ? []
          : List<Track>.from(
              (map['dailySongs'] as List<dynamic>).map<Track>(
                (x) => Track.fromMap(x as Map<String, dynamic>),
              ),
            ),
      recommend: map['recommend'] == null
          ? map['recommend']
          : List<RecommendReason>.from(
              (map['recommend'] as List<dynamic>).map<RecommendReason>(
                (x) => RecommendReason.fromMap(x as Map<String, dynamic>),
              ),
            ),
    );
  }

  String toJson() => json.encode(toMap());

  factory RecommendSongsResponseData.fromJson(String source) =>
      RecommendSongsResponseData.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class RecommendReason {
  final int songId;
  final String reason;
  final String reasonId;
  final dynamic targetUrl;
  RecommendReason({
    required this.songId,
    required this.reason,
    required this.reasonId,
    this.targetUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'songId': songId,
      'reason': reason,
      'reasonId': reasonId,
      'targetUrl': targetUrl,
    };
  }

  factory RecommendReason.fromMap(Map<String, dynamic> map) {
    return RecommendReason(
      songId: map['songId'] as int,
      reason: map['reason'] as String,
      reasonId: map['reasonId'] as String,
      targetUrl: map['targetUrl'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecommendReason.fromJson(String source) =>
      RecommendReason.fromMap(json.decode(source) as Map<String, dynamic>);
}
