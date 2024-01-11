import 'dart:convert';
import 'package:qianshi_music/models/album.dart';
import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/track.dart';

class AlbumResponse extends BaseResponse {
  final Album? album;
  final List<Track> songs;
  AlbumResponse({
    required super.code,
    super.msg,
    this.album,
    this.songs = const [],
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'songs': songs.map((x) => x.toMap()).toList(),
        'album': album?.toMap(),
      });
  }

  factory AlbumResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return AlbumResponse(
      code: base.code,
      msg: base.msg,
      album: map['album'] == null
          ? null
          : Album.fromMap(map['album'] as Map<String, dynamic>),
      songs: map['songs'] != null
          ? List<Track>.from(
              (map['songs'] as List<dynamic>).map<Track>(
                (x) => Track.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory AlbumResponse.fromJson(String source) =>
      AlbumResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
