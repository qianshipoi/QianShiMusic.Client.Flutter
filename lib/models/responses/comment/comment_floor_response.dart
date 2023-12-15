import 'dart:convert';
import 'package:qianshi_music/models/comment.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class CommentFloorResponse extends BaseResponse {
  final CommentFloorData? data;
  CommentFloorResponse({
    required super.code,
    super.msg,
    this.data,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'data': data,
      });
  }

  factory CommentFloorResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return CommentFloorResponse(
      code: base.code,
      msg: base.msg,
      data: CommentFloorData.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory CommentFloorResponse.fromJson(String source) =>
      CommentFloorResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class CommentFloorData {
  final Comment? ownerComment;
  final List<Comment> comments;
  final bool hasMore;
  final int totalCount;
  final int time;
  final List<Comment> bestComments;
  CommentFloorData({
    required this.ownerComment,
    required this.comments,
    required this.hasMore,
    required this.totalCount,
    required this.time,
    required this.bestComments,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ownerComment': ownerComment?.toMap(),
      'comments': comments.map((x) => x.toMap()).toList(),
      'hasMore': hasMore,
      'totalCount': totalCount,
      'time': time,
      'bestComments': bestComments.map((x) => x.toMap()).toList(),
    };
  }

  factory CommentFloorData.fromMap(Map<String, dynamic> map) {
    return CommentFloorData(
      ownerComment: map['ownerComment'] == null
          ? null
          : Comment.fromMap(map['ownerComment'] as Map<String, dynamic>),
      comments: List<Comment>.from(
        (map['comments'] as List<dynamic>).map<Comment>(
          (x) => Comment.fromMap(x as Map<String, dynamic>),
        ),
      ),
      hasMore: (map['hasMore'] as bool?) ?? false,
      totalCount: (map['totalCount'] as int?) ?? 0,
      time: (map['time'] as int?) ?? 0,
      bestComments: List<Comment>.from(
        (map['bestComments'] as List<dynamic>).map<Comment>(
          (x) => Comment.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentFloorData.fromJson(String source) =>
      CommentFloorData.fromMap(json.decode(source) as Map<String, dynamic>);
}
