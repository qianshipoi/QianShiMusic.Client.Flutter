import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/song_url.dart';
import 'package:qianshi_music/models/track.dart';

class SongUrlResponse extends BaseResponse {
  final SongUrl? data;

  SongUrlResponse({this.data, required super.code, super.msg});

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data?.toMap(),
      'code': code,
      'msg': msg,
    };
  }

  factory SongUrlResponse.fromMap(Map<String, dynamic> map) {
    return SongUrlResponse(
      code: map['code'] as int,
      msg: map['msg'] != null ? map['msg'] as String : null,
      data: map['data'] != null
          ? SongUrl.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory SongUrlResponse.fromJson(String source) =>
      SongUrlResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SongDetailResponse extends BaseResponse {
  final List<Track>? songs;

  SongDetailResponse({
    this.songs,
    required super.code,
    super.msg,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'songs': songs?.map((x) => x.toMap()).toList(),
      'code': code,
      'msg': msg,
    };
  }

  factory SongDetailResponse.fromMap(Map<String, dynamic> map) {
    return SongDetailResponse(
      code: map['code'] as int,
      msg: map['msg'] != null ? map['msg'] as String : null,
      songs: List<Track>.from(
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
