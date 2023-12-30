import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';

class CheckMusicResponse extends BaseResponse {
  final bool success;
  CheckMusicResponse({
    required super.code,
    super.msg,
    this.success = false,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'success': success,
      });
  }

  factory CheckMusicResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return CheckMusicResponse(
      code: base.code,
      msg: base.msg,
      success: map['success'] as bool,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory CheckMusicResponse.fromJson(String source) =>
      CheckMusicResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
