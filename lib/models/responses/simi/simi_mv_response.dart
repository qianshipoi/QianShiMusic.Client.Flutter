import 'dart:convert';

import 'package:qianshi_music/models/mv.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class SimiMvResponse extends BaseResponse {
  final List<Mv> mvs;
  SimiMvResponse({
    required super.code,
    super.msg,
    required this.mvs,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'mvs': mvs.map((x) => x.toMap()).toList(),
      });
  }

  factory SimiMvResponse.fromMap(Map<String, dynamic> map) {
    final baseResponse = BaseResponse.fromMap(map);
    return SimiMvResponse(
      code: baseResponse.code,
      msg: baseResponse.msg,
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

  factory SimiMvResponse.fromJson(String source) =>
      SimiMvResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
