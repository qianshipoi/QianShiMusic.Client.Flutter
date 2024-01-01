import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/track.dart';

class HistoryRecommendSongsResponse extends BaseResponse {
  final HistoryRecommendSongsDetail? data;
  HistoryRecommendSongsResponse({
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

  factory HistoryRecommendSongsResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return HistoryRecommendSongsResponse(
      code: base.code,
      msg: base.msg,
      data: map['data'] != null
          ? HistoryRecommendSongsDetail.fromMap(
              map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory HistoryRecommendSongsResponse.fromJson(String source) =>
      HistoryRecommendSongsResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class HistoryRecommendSongsDetail {
  final List<String> dates;
  final String description;
  final String noHistoryMessage;
  final List<Track> songs;
  HistoryRecommendSongsDetail({
    required this.dates,
    required this.description,
    required this.noHistoryMessage,
    this.songs = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dates': dates,
      'description': description,
      'noHistoryMessage': noHistoryMessage,
      'songs': songs.map((e) => e.toMap()),
    };
  }

  factory HistoryRecommendSongsDetail.fromMap(Map<String, dynamic> map) {
    return HistoryRecommendSongsDetail(
      dates: map['dates'] == null ? [] : map['dates'] as List<String>,
      description: map['description'] as String,
      noHistoryMessage: map['noHistoryMessage'] as String,
      songs: map['songs'] == null
          ? []
          : List<Track>.from(
              (map['songs'] as List<dynamic>).map((e) => Track.fromMap(e))),
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryRecommendSongsDetail.fromJson(String source) =>
      HistoryRecommendSongsDetail.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
