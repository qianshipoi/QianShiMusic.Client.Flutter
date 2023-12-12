import 'dart:convert';

import 'package:qianshi_music/models/comment.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class CommentMvResponse extends BaseResponse {
  final List<Comment> topComments;
  final List<Comment> hotComments;
  final List<Comment> comments;
  final bool more;
  final int total;
  CommentMvResponse({
    required super.code,
    super.msg,
    this.topComments = const [],
    this.hotComments = const [],
    this.comments = const [],
    this.more = false,
    this.total = 0,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll(<String, dynamic>{
        'topComments': topComments.map((x) => x.toMap()).toList(),
        'hotComments': hotComments.map((x) => x.toMap()).toList(),
        'comments': comments.map((x) => x.toMap()).toList(),
        'more': more,
        'total': total,
      });
  }

  factory CommentMvResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return CommentMvResponse(
      code: base.code,
      msg: base.msg,
      topComments: map['topComments'] == null
          ? []
          : List<Comment>.from(
              (map['topComments'] as List<dynamic>).map<Comment>(
                (x) => Comment.fromMap(x as Map<String, dynamic>),
              ),
            ),
      hotComments: map['hotComments'] == null
          ? []
          : List<Comment>.from(
              (map['hotComments'] as List<dynamic>).map<Comment>(
                (x) => Comment.fromMap(x as Map<String, dynamic>),
              ),
            ),
      comments: map['comments'] == null
          ? []
          : List<Comment>.from(
              (map['comments'] as List<dynamic>).map<Comment>(
                (x) => Comment.fromMap(x as Map<String, dynamic>),
              ),
            ),
      more: (map['more'] as bool?) ?? false,
      total: (map['total'] as int?) ?? 0,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory CommentMvResponse.fromJson(String source) =>
      CommentMvResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
