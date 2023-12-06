import 'dart:convert';

import 'package:qianshi_music/models/comment.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class CommentMvResponse extends BaseResponse {
  final List<Comment> topComments;
  final List<Comment> hotComments;
  final List<Comment> comments;
  final bool more;
  final int total;
  CommentMvResponse(
      {required this.topComments,
      required this.hotComments,
      required this.comments,
      required this.more,
      required this.total,
      required super.code,
      super.msg});

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'topComments': topComments.map((x) => x.toMap()).toList(),
      'hotComments': hotComments.map((x) => x.toMap()).toList(),
      'comments': comments.map((x) => x.toMap()).toList(),
      'more': more,
      'total': total,
    };
  }

  factory CommentMvResponse.fromMap(Map<String, dynamic> map) {
    return CommentMvResponse(
      topComments: List<Comment>.from(
        (map['topComments'] as List<int>).map<Comment>(
          (x) => Comment.fromMap(x as Map<String, dynamic>),
        ),
      ),
      hotComments: List<Comment>.from(
        (map['hotComments'] as List<int>).map<Comment>(
          (x) => Comment.fromMap(x as Map<String, dynamic>),
        ),
      ),
      comments: List<Comment>.from(
        (map['comments'] as List<int>).map<Comment>(
          (x) => Comment.fromMap(x as Map<String, dynamic>),
        ),
      ),
      more: map['more'] as bool,
      total: map['total'] as int,
      code: map['code'] as int,
      msg: map['msg'] as String?,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory CommentMvResponse.fromJson(String source) =>
      CommentMvResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
