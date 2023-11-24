import 'dart:convert';

import 'package:qianshi_music/models/playlist.dart';

class PlaylistTopResponse {
  final int code;
  final int? total;
  final bool? more;
  final List<Playlist>? playlists;
  PlaylistTopResponse({
    required this.code,
    this.total,
    this.more,
    this.playlists,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'total': total,
      'more': more,
      'playlists':
          playlists == null ? null : playlists!.map((x) => x.toMap()).toList(),
    };
  }

  factory PlaylistTopResponse.fromMap(Map<String, dynamic> map) {
    return PlaylistTopResponse(
      code: map['code'] as int,
      total: map['total'] != null ? map['total'] as int : null,
      more: map['more'] != null ? map['more'] as bool : null,
      playlists: map['playlists'] != null
          ? List<Playlist>.from((map['playlists'] as List<dynamic>)
              .map<Playlist>((x) => Playlist.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaylistTopResponse.fromJson(String source) =>
      PlaylistTopResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
