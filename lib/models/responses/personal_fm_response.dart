import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/track.dart';

class PersonalFmResponse extends BaseResponse {
  final List<Track> data;
  PersonalFmResponse({
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

  factory PersonalFmResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return PersonalFmResponse(
      code: base.code,
      msg: base.msg,
      data: map['data'] == null
          ? []
          : List<Track>.from(
              (map['data'] as List<dynamic>).map<Track>(
                (x) => Track.fromMap(x as Map<String, dynamic>),
              ),
            ),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory PersonalFmResponse.fromJson(String source) =>
      PersonalFmResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
