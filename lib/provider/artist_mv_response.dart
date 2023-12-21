import 'dart:convert';

import 'package:qianshi_music/models/mv.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class ArtistMvResponse extends BaseResponse {
  final bool hasMore;
  final int time;
  final List<Mv> mvs;
  ArtistMvResponse({
    required super.code,
    super.msg,
    this.hasMore = false,
    this.time = 0,
    this.mvs = const [],
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'hasMore': hasMore,
        'time': time,
        'mvs': mvs.map((x) => x.toMap()).toList(),
      });
  }

  factory ArtistMvResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return ArtistMvResponse(
      code: base.code,
      msg: base.msg,
      hasMore: (map['hasMore'] as bool?) ?? false,
      time: (map['time'] as int?) ?? 0,
      mvs: map['mvs'] == null
          ? []
          : List<Mv>.from(
              (map['mvs'] as List<dynamic>).map<Mv>(
                (x) => Mv.fromMap(x as Map<String, dynamic>),
              ),
            ),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory ArtistMvResponse.fromJson(String source) =>
      ArtistMvResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
