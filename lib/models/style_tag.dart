// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StyleTag {
  final int tagId;
  final String tagName;
  final String enName;
  final int level;
  final List<StyleTag> childrenTags;
  final String colorDeep;
  final String colorShallow;
  final String showText;
  final List<String> tabs;
  final String picUrl;

  StyleTag({
    required this.tagId,
    required this.tagName,
    required this.enName,
    required this.level,
    required this.childrenTags,
    required this.colorDeep,
    required this.colorShallow,
    required this.showText,
    required this.tabs,
    required this.picUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tagId': tagId,
      'tagName': tagName,
      'enName': enName,
      'level': level,
      'childrenTags': childrenTags.map((x) => x.toMap()).toList(),
      'colorDeep': colorDeep,
      'colorShallow': colorShallow,
      'showText': showText,
      'tabs': tabs,
      'picUrl': picUrl,
    };
  }

  factory StyleTag.fromMap(Map<String, dynamic> map) {
    return StyleTag(
      tagId: map['tagId'] as int,
      tagName: map['tagName'] as String,
      enName: map['enName'] as String,
      level: map['level'] as int,
      childrenTags: map['childrenTags'] == null
          ? []
          : List<StyleTag>.from(
              (map['childrenTags'] as List<dynamic>).map<StyleTag>(
              (x) => StyleTag.fromMap(x as Map<String, dynamic>),
            )),
      colorDeep: map['colorDeep'] as String,
      colorShallow: map['colorShallow'] as String,
      showText: map['showText'] as String,
      tabs: map['tabs'] == null
          ? []
          : List<String>.from((map['tabs'] as List<String>)),
      picUrl: map['picUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StyleTag.fromJson(String source) =>
      StyleTag.fromMap(json.decode(source) as Map<String, dynamic>);
}

class StyleTagPreferenceVos {
  final int tagId;
  final String tagName;
  final String ratio;
  final String picUrl;
  StyleTagPreferenceVos({
    required this.tagId,
    required this.tagName,
    required this.ratio,
    required this.picUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tagId': tagId,
      'tagName': tagName,
      'ratio': ratio,
      'picUrl': picUrl,
    };
  }

  factory StyleTagPreferenceVos.fromMap(Map<String, dynamic> map) {
    return StyleTagPreferenceVos(
      tagId: map['tagId'] as int,
      tagName: map['tagName'] as String,
      ratio: map['ratio'] as String,
      picUrl: map['picUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StyleTagPreferenceVos.fromJson(String source) =>
      StyleTagPreferenceVos.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
