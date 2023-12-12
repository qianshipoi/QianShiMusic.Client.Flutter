import 'dart:convert';

import 'package:qianshi_music/models/comment.dart';
import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/responses/comment/comment_new_response.dart';

class CommentNewMvResponse extends CommentNewResponse<CommentNewMvData> {
  CommentNewMvResponse({
    required super.code,
    super.msg,
    required super.data,
  });

  @override
  Map<String, dynamic> dataToMap() {
    return <String, dynamic>{
      'data': data?.toMap(),
    };
  }

  factory CommentNewMvResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return CommentNewMvResponse(
      code: base.code,
      msg: base.msg,
      data: map['data'] == null
          ? null
          : CommentNewMvData.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory CommentNewMvResponse.fromJson(String source) =>
      CommentNewMvResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class CommentNewMvData {
  final String commentsTitle;
  final List<Comment> comments;
  final String currentCommentTitle;
  final int totalCount;
  final bool hasMore;
  final String cursor;
  final int sortType;
  CommentNewMvData({
    required this.commentsTitle,
    required this.comments,
    required this.currentCommentTitle,
    required this.totalCount,
    required this.hasMore,
    required this.cursor,
    required this.sortType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentsTitle': commentsTitle,
      'comments': comments.map((x) => x.toMap()).toList(),
      'currentCommentTitle': currentCommentTitle,
      'totalCount': totalCount,
      'hasMore': hasMore,
      'cursor': cursor,
      'sortType': sortType,
    };
  }

  factory CommentNewMvData.fromMap(Map<String, dynamic> map) {
    return CommentNewMvData(
      commentsTitle: (map['commentsTitle'] as String?) ?? "",
      comments: List<Comment>.from(
        (map['comments'] as List<dynamic>).map<Comment>(
          (x) => Comment.fromMap(x as Map<String, dynamic>),
        ),
      ),
      currentCommentTitle: (map['currentCommentTitle'] as String?) ?? "",
      totalCount: (map['totalCount'] as int?) ?? 0,
      hasMore: (map['hasMore'] as bool?) ?? false,
      cursor: (map['cursor'] as String?) ?? "",
      sortType: map['sortType'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentNewMvData.fromJson(String source) =>
      CommentNewMvData.fromMap(json.decode(source) as Map<String, dynamic>);
}
