import 'dart:convert';

import 'package:qianshi_music/models/category.dart';

class PlaylistCatlistResponse {
  final int code;
  final String? msg;
  final Category? all;
  final List<Category>? sub;
  PlaylistCatlistResponse({
    required this.code,
    this.msg,
    this.all,
    this.sub,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'msg': msg,
      'all': all?.toMap(),
      'sub': sub?.map((x) => x.toMap()).toList(),
    };
  }

  factory PlaylistCatlistResponse.fromMap(Map<String, dynamic> map) {
    return PlaylistCatlistResponse(
      code: map['code'] as int,
      msg: map['msg'] != null ? map['msg'] as String : null,
      all: map['all'] != null
          ? Category.fromMap(map['all'] as Map<String, dynamic>)
          : null,
      sub: map['sub'] != null
          ? List<Category>.from(
              (map['sub'] as List<dynamic>).map<Category?>(
                (x) => Category.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaylistCatlistResponse.fromJson(String source) =>
      PlaylistCatlistResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
