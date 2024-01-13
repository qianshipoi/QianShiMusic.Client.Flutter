import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';

class ArtistDescResponse extends BaseResponse {
  final String briefDesc;
  final int count;
  final List<Introduction> introduction;
  ArtistDescResponse({
    required super.code,
    super.msg,
    this.briefDesc = '',
    this.count = 0,
    this.introduction = const [],
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'briefDesc': briefDesc,
        'count': count,
        'introduction': introduction.map((x) => x.toMap()).toList(),
      });
  }

  factory ArtistDescResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return ArtistDescResponse(
      code: base.code,
      msg: base.msg,
      briefDesc: (map['briefDesc'] as String?) ?? '',
      count: (map['count'] as int?) ?? 0,
      introduction: map['introduction'] == null
          ? []
          : List<Introduction>.from(
              (map['introduction'] as List<dynamic>).map<Introduction>(
                (x) => Introduction.fromMap(x as Map<String, dynamic>),
              ),
            ),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory ArtistDescResponse.fromJson(String source) =>
      ArtistDescResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Introduction {
  final String ti;
  final String txt;
  Introduction({
    required this.ti,
    required this.txt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ti': ti,
      'txt': txt,
    };
  }

  factory Introduction.fromMap(Map<String, dynamic> map) {
    return Introduction(
      ti: map['ti'] as String,
      txt: map['txt'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Introduction.fromJson(String source) =>
      Introduction.fromMap(json.decode(source) as Map<String, dynamic>);
}

// class Topic {
//   final int id;
//   final String mainTitle;
//   final String title;
//   final int userId;
//   final List<String> tags;
//   final String summary;
//   final int number;
// }
