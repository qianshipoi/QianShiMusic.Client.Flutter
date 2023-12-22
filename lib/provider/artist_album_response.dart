import 'dart:convert';

import 'package:qianshi_music/models/album.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class ArtistAlbumResponse extends BaseResponse {
  final bool more;
  final List<Album> hotAlbums;
  ArtistAlbumResponse({
    required super.code,
    super.msg,
    this.more = false,
    this.hotAlbums = const [],
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'hasMore': more,
        'hotAlbums': hotAlbums.map((x) => x.toMap()).toList(),
      });
  }

  factory ArtistAlbumResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return ArtistAlbumResponse(
      code: base.code,
      msg: base.msg,
      more: (map['hasMore'] as bool?) ?? false,
      hotAlbums: map['hotAlbums'] == null
          ? []
          : List<Album>.from(
              (map['hotAlbums'] as List<dynamic>).map<Album>(
                (x) => Album.fromMap(x as Map<String, dynamic>),
              ),
            ),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory ArtistAlbumResponse.fromJson(String source) =>
      ArtistAlbumResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
