import 'dart:convert';

import 'package:qianshi_music/models/artist.dart';
import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/responses/style/style_song_response.dart';

class StyleArtistResponse extends BaseResponse {
  final StyleArtistData? data;
  StyleArtistResponse({
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

  factory StyleArtistResponse.fromMap(Map<String, dynamic> map) {
    final superMap = BaseResponse.fromMap(map);
    return StyleArtistResponse(
      code: superMap.code,
      msg: superMap.msg,
      data: map['data'] != null
          ? StyleArtistData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory StyleArtistResponse.fromJson(String source) =>
      StyleArtistResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class StyleArtistData {
  final StyleDataPage page;
  final List<Artist> artists;
  StyleArtistData({
    required this.page,
    required this.artists,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page.toMap(),
      'artists': artists.map((x) => x.toMap()).toList(),
    };
  }

  factory StyleArtistData.fromMap(Map<String, dynamic> map) {
    return StyleArtistData(
      page: StyleDataPage.fromMap(map['page'] as Map<String, dynamic>),
      artists: List<Artist>.from(
        (map['artists'] as List<dynamic>).map<Artist>(
          (x) => Artist.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory StyleArtistData.fromJson(String source) =>
      StyleArtistData.fromMap(json.decode(source) as Map<String, dynamic>);
}
