// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/track.dart';

class ArtistTopSongsResponse extends BaseResponse {
  final bool more;
  final List<Track> songs;
  final int total;
  ArtistTopSongsResponse({
    required super.code,
    super.msg,
    this.more = false,
    this.songs = const [],
    this.total = 0,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'more': more,
        'songs': songs.map((x) => x.toMap()).toList(),
        'total': total,
      });
  }

  factory ArtistTopSongsResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return ArtistTopSongsResponse(
      code: base.code,
      msg: base.msg,
      more: (map['more'] as bool?) ?? false,
      songs: map['songs'] == null
          ? []
          : List<Track>.from(
              (map['songs'] as List<dynamic>).map<Track>(
                (x) => Track.fromMap(x as Map<String, dynamic>),
              ),
            ),
      total: (map['total'] as int?) ?? 0,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory ArtistTopSongsResponse.fromJson(String source) =>
      ArtistTopSongsResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
