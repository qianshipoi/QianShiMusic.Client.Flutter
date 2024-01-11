import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/track.dart';

class SimiSongResponse extends BaseResponse {
  final List<Track> songs;
  SimiSongResponse({
    required super.code,
    super.msg,
    required this.songs,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'songs': songs.map((x) => x.toMap()).toList(),
      });
  }

  factory SimiSongResponse.fromMap(Map<String, dynamic> map) {
    final baseResponse = BaseResponse.fromMap(map);
    return SimiSongResponse(
      code: baseResponse.code,
      msg: baseResponse.msg,
      songs: map['songs'] == null
          ? []
          : List<Track>.from(
              (map['songs'] as List<dynamic>).map<Track>(
                (x) => Track.fromMap(x as Map<String, dynamic>),
              ),
            ),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory SimiSongResponse.fromJson(String source) =>
      SimiSongResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
