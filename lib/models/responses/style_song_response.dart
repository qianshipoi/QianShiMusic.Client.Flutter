import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/track.dart';

class StyleSongResponse extends BaseResponse {
  final StyleSongData? data;
  StyleSongResponse({
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

  factory StyleSongResponse.fromMap(Map<String, dynamic> map) {
    final superMap = BaseResponse.fromMap(map);
    return StyleSongResponse(
      code: superMap.code,
      msg: superMap.msg,
      data: map['data'] != null
          ? StyleSongData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory StyleSongResponse.fromJson(String source) =>
      StyleSongResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class StyleSongData {
  final StyleDataPage page;
  final List<Track> songs;
  StyleSongData({
    required this.page,
    required this.songs,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page.toMap(),
      'songs': songs.map((x) => x.toMap()).toList(),
    };
  }

  factory StyleSongData.fromMap(Map<String, dynamic> map) {
    return StyleSongData(
      page: StyleDataPage.fromMap(map['page'] as Map<String, dynamic>),
      songs: List<Track>.from(
        (map['songs'] as List<dynamic>).map<Track>(
          (x) => Track.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory StyleSongData.fromJson(String source) =>
      StyleSongData.fromMap(json.decode(source) as Map<String, dynamic>);
}

class StyleDataPage {
  final int cursor;
  final int size;
  final int total;
  final bool more;
  StyleDataPage({
    required this.cursor,
    required this.size,
    required this.total,
    required this.more,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cursor': cursor,
      'size': size,
      'total': total,
      'more': more,
    };
  }

  factory StyleDataPage.fromMap(Map<String, dynamic> map) {
    return StyleDataPage(
      cursor: map['cursor'] as int,
      size: map['size'] as int,
      total: map['total'] as int,
      more: map['more'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory StyleDataPage.fromJson(String source) =>
      StyleDataPage.fromMap(json.decode(source) as Map<String, dynamic>);
}
