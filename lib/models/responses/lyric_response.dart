import 'dart:convert';

import 'package:qianshi_music/models/lyric.dart';

class LyricResponse {
  final int? code;
  final String? msg;
  final Lyric? lrc;
  final Lyric? klyric;
  final Lyric? tlyric;
  final Lyric? romalrc;
  LyricResponse({
    this.code,
    this.msg,
    this.lrc,
    this.klyric,
    this.tlyric,
    this.romalrc,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'msg': msg,
      'lrc': lrc?.toMap(),
      'klyric': klyric?.toMap(),
      'tlyric': tlyric?.toMap(),
      'romalrc': romalrc?.toMap(),
    };
  }

  factory LyricResponse.fromMap(Map<String, dynamic> map) {
    return LyricResponse(
      code: map['code'] != null ? map['code'] as int : null,
      msg: map['msg'] != null ? map['msg'] as String : null,
      lrc: map['lrc'] != null ? Lyric.fromMap(map['lrc'] as Map<String,dynamic>) : null,
      klyric: map['klyric'] != null ? Lyric.fromMap(map['klyric'] as Map<String,dynamic>) : null,
      tlyric: map['tlyric'] != null ? Lyric.fromMap(map['tlyric'] as Map<String,dynamic>) : null,
      romalrc: map['romalrc'] != null ? Lyric.fromMap(map['romalrc'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LyricResponse.fromJson(String source) =>
      LyricResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
