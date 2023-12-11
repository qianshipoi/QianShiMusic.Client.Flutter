import 'dart:convert';

import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class UserPlaylistResponse extends BaseResponse {
  final List<Playlist> playlist;
  UserPlaylistResponse({
    required super.code,
    super.msg,
    this.playlist = const [],
  });

  UserPlaylistResponse.base({
    required BaseResponse baseResponse,
    required this.playlist,
  }) : super(code: baseResponse.code, msg: baseResponse.msg);

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'playlist': playlist.map((x) => x.toMap()).toList(),
      });
  }

  factory UserPlaylistResponse.fromMap(Map<String, dynamic> map) {
    return UserPlaylistResponse.base(
      baseResponse: BaseResponse.fromMap(map),
      playlist: map['playlist'] == null
          ? []
          : List<Playlist>.from(
              (map['playlist'] as List<dynamic>).map<Playlist>(
                (x) => Playlist.fromMap(x as Map<String, dynamic>),
              ),
            ),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory UserPlaylistResponse.fromJson(String source) =>
      UserPlaylistResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
