import 'dart:convert';

import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/responses/style_song_response.dart';

class StylePlaylistResponse extends BaseResponse {
  final StylePlaylistData? data;
  StylePlaylistResponse({
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

  factory StylePlaylistResponse.fromMap(Map<String, dynamic> map) {
    final superMap = BaseResponse.fromMap(map);
    return StylePlaylistResponse(
      code: superMap.code,
      msg: superMap.msg,
      data: map['data'] != null
          ? StylePlaylistData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory StylePlaylistResponse.fromJson(String source) =>
      StylePlaylistResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class StylePlaylistData {
  final StyleDataPage page;
  final List<Playlist> playlist;
  StylePlaylistData({
    required this.page,
    required this.playlist,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page.toMap(),
      'playlist': playlist.map((x) => x.toMap()).toList(),
    };
  }

  factory StylePlaylistData.fromMap(Map<String, dynamic> map) {
    return StylePlaylistData(
      page: StyleDataPage.fromMap(map['page'] as Map<String, dynamic>),
      playlist: List<Playlist>.from(
        (map['playlist'] as List<dynamic>).map<Playlist>(
          (x) => Playlist.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory StylePlaylistData.fromJson(String source) =>
      StylePlaylistData.fromMap(json.decode(source) as Map<String, dynamic>);
}
