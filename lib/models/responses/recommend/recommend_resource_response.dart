import 'dart:convert';
import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class RecommendResourceResponse extends BaseResponse {
  final List<Playlist> recommend;
  RecommendResourceResponse({
    required super.code,
    this.recommend = const [],
    super.msg,
  });
  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll(<String, dynamic>{
        'recommend': recommend.map((x) => x.toMap()).toList(),
      });
  }

  factory RecommendResourceResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return RecommendResourceResponse(
      code: base.code,
      msg: base.msg,
      recommend: map['recommend'] == null
          ? []
          : List<Playlist>.from(
              (map['recommend'] as List<dynamic>).map<Playlist>(
                (x) => Playlist.fromMap(x as Map<String, dynamic>),
              ),
            ),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory RecommendResourceResponse.fromJson(String source) =>
      RecommendResourceResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
