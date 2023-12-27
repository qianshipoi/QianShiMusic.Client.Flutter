import 'dart:convert';

import 'package:qianshi_music/models/artist.dart';
import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/track.dart';

class ArtistsResponse extends BaseResponse {
  final Artist? artist;
  final List<Track> hotSongs;
  final bool more;
  ArtistsResponse({
    required super.code,
    super.msg,
    this.artist,
    this.hotSongs = const [],
    this.more = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'artist': artist?.toMap(),
        'hotSongs': hotSongs.map((x) => x.toMap()).toList(),
        'more': more,
      });
  }

  factory ArtistsResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return ArtistsResponse(
      code: base.code,
      msg: base.msg,
      artist: map['artist'] != null
          ? Artist.fromMap(map['artist'] as Map<String, dynamic>)
          : null,
      hotSongs: map['hotSongs'] == null
          ? []
          : List<Track>.from(
              (map['hotSongs'] as List<dynamic>).map<Track>(
                (x) => Track.fromMap(x as Map<String, dynamic>),
              ),
            ),
      more: map['more'] as bool,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory ArtistsResponse.fromJson(String source) =>
      ArtistsResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
