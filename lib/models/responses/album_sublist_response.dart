import 'dart:convert';

import 'package:qianshi_music/models/album.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class AlbumSublistResponse extends BaseResponse {
  final int count;
  final bool hasMore;
  final int paidCount;
  final List<Album> data;
  AlbumSublistResponse({
    required super.code,
    super.msg,
    this.count = 0,
    this.hasMore = false,
    this.paidCount = 0,
    this.data = const [],
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'count': count,
        'hasMore': hasMore,
        'paidCount': paidCount,
        'data': data.map((x) => x.toMap()).toList(),
      });
  }

  factory AlbumSublistResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return AlbumSublistResponse(
      code: base.code,
      msg: base.msg,
      count: map['count'] as int,
      hasMore: map['hasMore'] as bool,
      paidCount: map['paidCount'] as int,
      data: map['data'] != null
          ? List<Album>.from(
              (map['data'] as List<dynamic>).map<Album>(
                (x) => Album.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory AlbumSublistResponse.fromJson(String source) =>
      AlbumSublistResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
