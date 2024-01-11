import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';

class PlaylistTracksResponse {
  final int status;
  final PlaylistTracksResponseBody body;
  PlaylistTracksResponse({
    required this.status,
    required this.body,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'body': body.toMap(),
    };
  }

  factory PlaylistTracksResponse.fromMap(Map<String, dynamic> map) {
    return PlaylistTracksResponse(
      status: map['status'] as int,
      body: PlaylistTracksResponseBody.fromMap(
          map['body'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaylistTracksResponse.fromJson(String source) =>
      PlaylistTracksResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class PlaylistTracksResponseBody extends BaseResponse {
  final String coverImgUrl;
  final String coverImgId;
  final List<int> trackIds;
  final int count;
  final int cloudCount;
  PlaylistTracksResponseBody({
    required super.code,
    super.msg,
    this.coverImgUrl = '',
    this.coverImgId = '',
    this.trackIds = const [],
    this.count = 0,
    this.cloudCount = 0,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'coverImgUrl': coverImgUrl,
        'coverImgId': coverImgId,
        'trackIds': '[${trackIds.join(',')}]',
        'count': count,
        'cloudCount': cloudCount,
      });
  }

  factory PlaylistTracksResponseBody.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return PlaylistTracksResponseBody(
      code: base.code,
      msg: base.msg,
      coverImgUrl: (map['coverImgUrl'] as String?) ?? '',
      coverImgId: (map['coverImgId'] as String?) ?? '',
      trackIds: map['trackIds'] == null
          ? []
          : List<int>.from((map['trackIds'] as String)
              .replaceAll('[', '')
              .replaceAll(']', '')
              .split(',')
              .map((e) => int.parse(e))),
      count: (map['count'] as int?) ?? 0,
      cloudCount: (map['cloudCount'] as int?) ?? 0,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory PlaylistTracksResponseBody.fromJson(String source) =>
      PlaylistTracksResponseBody.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
