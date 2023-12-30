// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class PersonalizedResponse extends BaseResponse {
  final List<Playlist> result;
  PersonalizedResponse({
    required super.code,
    super.msg,
    this.result = const [],
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'result': result.map((x) => x.toMap()).toList(),
      });
  }

  factory PersonalizedResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return PersonalizedResponse(
      code: base.code,
      msg: base.msg,
      result: List<Playlist>.from(
        (map['result'] as List<dynamic>).map<Playlist>(
          (x) => Playlist.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory PersonalizedResponse.fromJson(String source) =>
      PersonalizedResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
