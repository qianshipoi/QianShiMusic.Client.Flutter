import 'dart:convert';

import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class PlaylistTopResponse extends BaseResponse {
  final int total;
  final bool more;
  final List<Playlist> playlists;
  PlaylistTopResponse({
    required super.code,
    super.msg,
    this.total = 0,
    this.more = false,
    this.playlists = const [],
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'total': total,
        'more': more,
        'playlists': playlists.map((x) => x.toMap()).toList(),
      });
  }

  factory PlaylistTopResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return PlaylistTopResponse(
      code: base.code,
      msg: base.msg,
      total: (map['total'] as int?) ?? 0,
      more: (map['more'] as bool?) ?? false,
      playlists: map['playlists'] != null
          ? List<Playlist>.from((map['playlists'] as List<dynamic>)
              .map<Playlist>((x) => Playlist.fromMap(x)))
          : [],
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory PlaylistTopResponse.fromJson(String source) =>
      PlaylistTopResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
