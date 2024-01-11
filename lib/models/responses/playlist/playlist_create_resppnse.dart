import 'dart:convert';

import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class PlaylistCreateResponse extends BaseResponse {
  final int id;
  final Playlist? playlist;
  PlaylistCreateResponse({
    required super.code,
    super.msg,
    required this.id,
    this.playlist,
  });
  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll(<String, dynamic>{
        'id': id,
        'playlist': playlist?.toMap(),
      });
  }

  factory PlaylistCreateResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return PlaylistCreateResponse(
      code: base.code,
      msg: base.msg,
      id: map['id'] as int,
      playlist: map['playlist'] != null
          ? Playlist.fromMap(map['playlist'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory PlaylistCreateResponse.fromJson(String source) =>
      PlaylistCreateResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
