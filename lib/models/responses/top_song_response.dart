// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/track.dart';

class TopSongResponse extends BaseResponse {
  final List<Track> data;
  TopSongResponse({
    required super.code,
    super.msg,
    this.data = const [],
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'data': data.map((x) => x.toMap()).toList(),
      });
  }

  factory TopSongResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return TopSongResponse(
      code: base.code,
      msg: base.msg,
      data: map['data'] == null
          ? []
          : List<Track>.from(
              (map['data'] as List<dynamic>).map<Track>(
                (x) => Track.fromMap(x as Map<String, dynamic>),
              ),
            ),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory TopSongResponse.fromJson(String source) =>
      TopSongResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
