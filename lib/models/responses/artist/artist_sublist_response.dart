import 'dart:convert';
import 'package:qianshi_music/models/artist.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class ArtistSublistResponse extends BaseResponse {
  final int count;
  final bool hasMore;
  final List<Artist> data;
  ArtistSublistResponse({
    required super.code,
    super.msg,
    this.count = 0,
    this.hasMore = false,
    this.data = const [],
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'count': count,
        'hasMore': hasMore,
        'data': data.map((x) => x.toMap()).toList(),
      });
  }

  factory ArtistSublistResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return ArtistSublistResponse(
      code: base.code,
      msg: base.msg,
      count: map['count'] as int,
      hasMore: map['hasMore'] as bool,
      data: map['data'] != null
          ? List<Artist>.from(
              (map['data'] as List<dynamic>).map<Artist>(
                (x) => Artist.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory ArtistSublistResponse.fromJson(String source) =>
      ArtistSublistResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
