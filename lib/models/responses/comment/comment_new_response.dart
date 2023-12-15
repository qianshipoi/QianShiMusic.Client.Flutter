import 'dart:convert';

import 'package:qianshi_music/models/comment.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class CommentNewResponse extends BaseResponse {
  final CommentNewData? data;
  CommentNewResponse({
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

  factory CommentNewResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return CommentNewResponse(
      code: base.code,
      msg: base.msg,
      data: map['data'] == null
          ? null
          : CommentNewData.fromMap(map['data'] as Map<String, dynamic>),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory CommentNewResponse.fromJson(String source) =>
      CommentNewResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class CommentNewData {
  final String commentsTitle;
  final List<Comment> comments;
  final String currentCommentTitle;
  final int totalCount;
  final bool hasMore;
  final String cursor;
  final int sortType;
  CommentNewData({
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

  factory CommentNewData.fromMap(Map<String, dynamic> map) {
    return CommentNewData(
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

  factory CommentNewData.fromJson(String source) =>
      CommentNewData.fromMap(json.decode(source) as Map<String, dynamic>);
}
