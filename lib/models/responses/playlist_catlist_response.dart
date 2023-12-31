import 'dart:convert';

import 'package:qianshi_music/models/category.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class PlaylistCatlistResponse extends BaseResponse {
  final Category? all;
  final List<Category> sub;
  final Map<String, String>? categories;
  PlaylistCatlistResponse({
    required super.code,
    super.msg,
    this.all,
    this.sub = const [],
    this.categories,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'all': all?.toMap(),
        'sub': sub.map((x) => x.toMap()).toList(),
        'categories': categories
      });
  }

  factory PlaylistCatlistResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return PlaylistCatlistResponse(
      code: base.code,
      msg: base.msg,
      all: map['all'] != null
          ? Category.fromMap(map['all'] as Map<String, dynamic>)
          : null,
      sub: map['sub'] != null
          ? List<Category>.from(
              (map['sub'] as List<dynamic>).map<Category?>(
                (x) => Category.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      categories: map['categories'] != null
          ? Map<String, String>.from(map['categories'])
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory PlaylistCatlistResponse.fromJson(String source) =>
      PlaylistCatlistResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
