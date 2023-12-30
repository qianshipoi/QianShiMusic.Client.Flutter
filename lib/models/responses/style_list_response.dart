import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/style_tag.dart';

class StyleListResponse extends BaseResponse {
  final List<StyleTag> data;
  StyleListResponse({
    required super.code,
    super.msg,
    this.data = const [],
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()..addAll(<String, dynamic>{'data': data});
  }

  factory StyleListResponse.fromMap(Map<String, dynamic> map) {
    final superMap = BaseResponse.fromMap(map);
    return StyleListResponse(
      code: superMap.code,
      msg: superMap.msg,
      data: List<StyleTag>.from(
        (map['data'] as List<dynamic>).map<StyleTag>(
          (x) => StyleTag.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory StyleListResponse.fromJson(String source) =>
      StyleListResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
