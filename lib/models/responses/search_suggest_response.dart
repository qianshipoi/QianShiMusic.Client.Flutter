import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';

class SearchSuggestResponse extends BaseResponse {
  final SearchSuggestResult? result;
  SearchSuggestResponse({
    required super.code,
    super.msg,
    this.result,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'result': result?.toMap(),
      });
  }

  factory SearchSuggestResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return SearchSuggestResponse(
      code: base.code,
      msg: base.msg,
      result: map['result'] != null
          ? SearchSuggestResult.fromMap(map['result'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory SearchSuggestResponse.fromJson(String source) =>
      SearchSuggestResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class SearchSuggestResult {
  final List<SearchSuggestResultMatch> allMatch;
  SearchSuggestResult({
    required this.allMatch,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'allMatch': allMatch.map((x) => x.toMap()).toList(),
    };
  }

  factory SearchSuggestResult.fromMap(Map<String, dynamic> map) {
    return SearchSuggestResult(
      allMatch: List<SearchSuggestResultMatch>.from(
        (map['allMatch'] as List<dynamic>).map<SearchSuggestResultMatch>(
          (x) => SearchSuggestResultMatch.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchSuggestResult.fromJson(String source) =>
      SearchSuggestResult.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SearchSuggestResultMatch {
  final String keyword;
  final int type;
  SearchSuggestResultMatch({
    required this.keyword,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'keyword': keyword,
      'type': type,
    };
  }

  factory SearchSuggestResultMatch.fromMap(Map<String, dynamic> map) {
    return SearchSuggestResultMatch(
      keyword: map['keyword'] as String,
      type: map['type'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchSuggestResultMatch.fromJson(String source) =>
      SearchSuggestResultMatch.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
