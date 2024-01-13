// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/track.dart';

class SongDetailResponse extends BaseResponse {
  final List<Track> songs;

  SongDetailResponse({
    required super.code,
    super.msg,
    this.songs = const [],
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'songs': songs.map((x) => x.toMap()).toList(),
      });
  }

  factory SongDetailResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return SongDetailResponse(
      code: base.code,
      msg: base.msg,
      songs: map['songs'] == null
          ? []
          : List<Track>.from(
              (map['songs'] as List<dynamic>).map<Track>(
                (x) => Track.fromMap(x as Map<String, dynamic>),
              ),
            ),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory SongDetailResponse.fromJson(String source) =>
      SongDetailResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
