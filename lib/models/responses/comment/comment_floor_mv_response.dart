import 'dart:convert';
import 'package:qianshi_music/models/comment.dart';
import 'package:qianshi_music/models/responses/comment/comment_floor_response.dart';

class CommentFloorMvResponse extends CommentFloorResponse<CommentFloorMvData> {
  CommentFloorMvResponse({
    required super.code,
    super.msg,
    super.data,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'msg': msg,
      'data': data?.toMap(),
    };
  }

  factory CommentFloorMvResponse.fromMap(Map<String, dynamic> map) {
    return CommentFloorMvResponse(
      code: (map['code'] as int?) ?? 0,
      msg: ((map['msg'] ?? map['message']) as String?) ?? '',
      data: CommentFloorMvData.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory CommentFloorMvResponse.fromJson(String source) =>
      CommentFloorMvResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class CommentFloorMvData {
  final Comment? ownerComment;
  final List<Comment> comments;
  final bool hasMore;
  final int totalCount;
  final int time;
  final List<Comment> bestComments;
  CommentFloorMvData({
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

  factory CommentFloorMvData.fromMap(Map<String, dynamic> map) {
    return CommentFloorMvData(
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

  factory CommentFloorMvData.fromJson(String source) =>
      CommentFloorMvData.fromMap(json.decode(source) as Map<String, dynamic>);
}
