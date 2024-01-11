import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';

class PlaylistCoverUpdateResponse extends BaseResponse {
  final PlaylistCoverUpdateData? data;
  PlaylistCoverUpdateResponse({
    required super.code,
    super.msg,
    this.data,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'data': data?.toMap(),
      });
  }

  factory PlaylistCoverUpdateResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return PlaylistCoverUpdateResponse(
      code: base.code,
      msg: base.msg,
      data: map['data'] != null
          ? PlaylistCoverUpdateData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory PlaylistCoverUpdateResponse.fromJson(String source) =>
      PlaylistCoverUpdateResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class PlaylistCoverUpdateData {
  final String url;
  PlaylistCoverUpdateData({
    required this.url,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
    };
  }

  factory PlaylistCoverUpdateData.fromMap(Map<String, dynamic> map) {
    return PlaylistCoverUpdateData(
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaylistCoverUpdateData.fromJson(String source) =>
      PlaylistCoverUpdateData.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
