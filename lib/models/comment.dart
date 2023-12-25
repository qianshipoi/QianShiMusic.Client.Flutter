import 'dart:convert';

class Comment {
  final int commentId;
  final String content;
  final int time;
  final String timeStr;
  final int likedCount;
  final bool liked;
  final CommentUser user;
  final List<Comment> beReplied;
  final int? beRepliedCommentId;
  final int replyCount;
  Comment({
    required this.commentId,
    required this.content,
    required this.time,
    required this.timeStr,
    required this.likedCount,
    required this.liked,
    required this.user,
    required this.beReplied,
    this.beRepliedCommentId,
    required this.replyCount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'content': content,
      'time': time,
      'timeStr': timeStr,
      'likedCount': likedCount,
      'liked': liked,
      'user': user.toMap(),
      'beReplied': beReplied.map((x) => x.toMap()).toList(),
      'beRepliedCommentId': beRepliedCommentId,
      'replyCount': replyCount,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentId: map['commentId'] as int,
      content: map['content'] as String,
      time: map['time'] as int,
      timeStr: map['timeStr'] as String,
      likedCount: map['likedCount'] as int,
      liked: map['liked'] as bool,
      user: CommentUser.fromMap(map['user'] as Map<String, dynamic>),
      beReplied: [],
      beRepliedCommentId: map['beRepliedCommentId'] != null
          ? map['beRepliedCommentId'] as int
          : null,
      replyCount: (map['replyCount'] as int?) ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source) as Map<String, dynamic>);

  Comment copyWith({
    int? commentId,
    String? content,
    int? time,
    String? timeStr,
    int? likedCount,
    bool? liked,
    CommentUser? user,
    List<Comment>? beReplied,
    int? beRepliedCommentId,
    int? replyCount,
  }) {
    return Comment(
      commentId: commentId ?? this.commentId,
      content: content ?? this.content,
      time: time ?? this.time,
      timeStr: timeStr ?? this.timeStr,
      likedCount: likedCount ?? this.likedCount,
      liked: liked ?? this.liked,
      user: user ?? this.user,
      beReplied: beReplied ?? this.beReplied,
      beRepliedCommentId: beRepliedCommentId ?? this.beRepliedCommentId,
      replyCount: replyCount ?? this.replyCount,
    );
  }
}

class CommentUser {
  final int userId;
  final String nickname;
  final String avatarUrl;
  final bool followed;
  final int userType;
  CommentUser({
    required this.userId,
    required this.nickname,
    required this.avatarUrl,
    required this.followed,
    required this.userType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'nickname': nickname,
      'avatarUrl': avatarUrl,
      'followed': followed,
      'userType': userType,
    };
  }

  factory CommentUser.fromMap(Map<String, dynamic> map) {
    return CommentUser(
      userId: map['userId'] as int,
      nickname: map['nickname'] as String,
      avatarUrl: map['avatarUrl'] as String,
      followed: (map['followed'] as bool?) ?? false,
      userType: map['userType'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentUser.fromJson(String source) =>
      CommentUser.fromMap(json.decode(source) as Map<String, dynamic>);
}
