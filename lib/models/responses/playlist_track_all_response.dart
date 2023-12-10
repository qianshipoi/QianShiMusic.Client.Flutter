import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/track.dart';

class PlaylistTrackAllResponse extends BaseResponse {
  final List<Track> songs;
  PlaylistTrackAllResponse({
    required this.songs,
    required super.code,
    super.msg,
  });

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'songs': songs.map((x) => x.toMap()).toList(),
    };
    map.addAll(super.toMap());
    return map;
  }

  factory PlaylistTrackAllResponse.fromMap(Map<String, dynamic> map) {
    return PlaylistTrackAllResponse(
      msg: (map['msg'] ?? map['message']) as String?,
      code: map['code'] as int,
      songs: List<Track>.from(
        (map['songs'] as List<dynamic>).map<Track>(
          (x) => Track.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory PlaylistTrackAllResponse.fromJson(String source) =>
      PlaylistTrackAllResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
