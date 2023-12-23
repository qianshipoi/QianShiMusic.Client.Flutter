import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/song_url.dart';

class SongUrlResponse extends BaseResponse {
  final List<SongUrl> data;
  SongUrlResponse({
    required super.code,
    super.msg,
    this.data = const [],
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'data': data.map((x) => x.toMap()).toList(),
      });
  }

  factory SongUrlResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return SongUrlResponse(
      code: base.code,
      msg: base.msg,
      data: map['data'] != null
          ? List<SongUrl>.from(
              (map['data'] as List<dynamic>).map<SongUrl?>(
                (x) => SongUrl.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory SongUrlResponse.fromJson(String source) =>
      SongUrlResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

