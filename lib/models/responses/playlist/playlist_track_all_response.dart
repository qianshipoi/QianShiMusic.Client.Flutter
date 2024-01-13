import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/track.dart';

class PlaylistTrackAllResponse extends BaseResponse {
  final List<Track> songs;
  PlaylistTrackAllResponse({
    this.songs = const [],
    required super.code,
    super.msg,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'songs': songs.map((x) => x.toMap()).toList(),
      });
  }

  factory PlaylistTrackAllResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return PlaylistTrackAllResponse(
      code: base.code,
      msg: base.msg,
      songs: List<Track>.from(
        (map['songs'] as List<dynamic>).map<Track>(
          (x) => Track.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory PlaylistTrackAllResponse.fromJson(String source) =>
      PlaylistTrackAllResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
