import 'dart:convert';

import 'package:qianshi_music/models/lyric.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class LyricResponse extends BaseResponse {
  final Lyric? lrc;
  final Lyric? klyric;
  final Lyric? tlyric;
  final Lyric? romalrc;
  LyricResponse({
    required super.code,
    super.msg,
    this.lrc,
    this.klyric,
    this.tlyric,
    this.romalrc,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'lrc': lrc?.toMap(),
        'klyric': klyric?.toMap(),
        'tlyric': tlyric?.toMap(),
        'romalrc': romalrc?.toMap(),
      });
  }

  factory LyricResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return LyricResponse(
      code: base.code,
      msg: base.msg,
      lrc: map['lrc'] != null
          ? Lyric.fromMap(map['lrc'] as Map<String, dynamic>)
          : null,
      klyric: map['klyric'] != null
          ? Lyric.fromMap(map['klyric'] as Map<String, dynamic>)
          : null,
      tlyric: map['tlyric'] != null
          ? Lyric.fromMap(map['tlyric'] as Map<String, dynamic>)
          : null,
      romalrc: map['romalrc'] != null
          ? Lyric.fromMap(map['romalrc'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory LyricResponse.fromJson(String source) =>
      LyricResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
