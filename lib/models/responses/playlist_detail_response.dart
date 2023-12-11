import 'dart:convert';

import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class PlaylistDetailResponse extends BaseResponse {
  final Playlist? playlist;
  PlaylistDetailResponse({
    required super.code,
    super.msg,
    this.playlist,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'playlist': playlist?.toMap(),
      'code': code,
      'msg': msg,
    };
  }

  factory PlaylistDetailResponse.fromMap(Map<String, dynamic> map) {
    return PlaylistDetailResponse(
      code: map['code'] as int,
      msg: (map['msg'] ?? map['message']) as String?,
      playlist: map['playlist'] == null
          ? null
          : Playlist.fromMap(map['playlist'] as Map<String, dynamic>),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory PlaylistDetailResponse.fromJson(String source) =>
      PlaylistDetailResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
