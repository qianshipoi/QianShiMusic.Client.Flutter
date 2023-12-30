import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/style_tag.dart';

class StylePreferenceResponse extends BaseResponse {
  final StylePreferenceData? data;
  StylePreferenceResponse({
    required super.code,
    super.msg,
    this.data,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll(<String, dynamic>{
        'data': data?.toMap(),
      });
  }

  factory StylePreferenceResponse.fromMap(Map<String, dynamic> map) {
    final superMap = BaseResponse.fromMap(map);
    return StylePreferenceResponse(
      code: superMap.code,
      msg: superMap.msg,
      data: map['data'] != null
          ? StylePreferenceData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory StylePreferenceResponse.fromJson(String source) =>
      StylePreferenceResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class StylePreferenceData {
  final List<StyleTagPreferenceVos> tagPreferenceVos;
  final List<StyleTag> tags;
  StylePreferenceData({
    required this.tagPreferenceVos,
    required this.tags,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tagPreferenceVos': tagPreferenceVos.map((x) => x.toMap()).toList(),
      'tags': tags.map((x) => x.toMap()).toList(),
    };
  }

  factory StylePreferenceData.fromMap(Map<String, dynamic> map) {
    return StylePreferenceData(
      tagPreferenceVos: List<StyleTagPreferenceVos>.from(
        (map['tagPreferenceVos'] as List<dynamic>).map<StyleTagPreferenceVos>(
          (x) => StyleTagPreferenceVos.fromMap(x as Map<String, dynamic>),
        ),
      ),
      tags: List<StyleTag>.from(
        (map['tags'] as List<dynamic>).map<StyleTag>(
          (x) => StyleTag.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory StylePreferenceData.fromJson(String source) =>
      StylePreferenceData.fromMap(json.decode(source) as Map<String, dynamic>);
}
