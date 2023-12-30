import 'dart:convert';

import 'package:qianshi_music/models/album.dart';
import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/responses/style_song_response.dart';

class StyleAlbumResponse extends BaseResponse {
  final StyleAlbumData? data;
  StyleAlbumResponse({
    required super.code,
    super.msg,
    this.data,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll(<String, dynamic>{
        'data': data?.toMap(),
      });
  }

  factory StyleAlbumResponse.fromMap(Map<String, dynamic> map) {
    final superMap = BaseResponse.fromMap(map);
    return StyleAlbumResponse(
      code: superMap.code,
      msg: superMap.msg,
      data: map['data'] != null
          ? StyleAlbumData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory StyleAlbumResponse.fromJson(String source) =>
      StyleAlbumResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class StyleAlbumData {
  final StyleDataPage page;
  final List<Album> albums;
  StyleAlbumData({
    required this.page,
    required this.albums,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page.toMap(),
      'albums': albums.map((x) => x.toMap()).toList(),
    };
  }

  factory StyleAlbumData.fromMap(Map<String, dynamic> map) {
    return StyleAlbumData(
      page: StyleDataPage.fromMap(map['page'] as Map<String, dynamic>),
      albums: List<Album>.from(
        (map['albums'] as List<dynamic>).map<Album>(
          (x) => Album.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory StyleAlbumData.fromJson(String source) =>
      StyleAlbumData.fromMap(json.decode(source) as Map<String, dynamic>);
}
