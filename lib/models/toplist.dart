import 'dart:convert';

class Toplist {
  final String updateFrequency;
  final int trackNumberUpdateTime;
  final int subscribedCount;
  final int specialType;
  final int updateTime;
  final int coverImgUrl;
  final int coverImgId;
  final int trackCount;
  final String commentThreadId;
  final int trackUpdateTime;
  final int playCount;
  final int createTime;
  final bool ordered;
  final String description;
  final int status;
  final List<String> tags;
  final int userId;
  final int id;
  final String name;
  final List<ToplistSong> tracks;
  Toplist({
    required this.updateFrequency,
    required this.trackNumberUpdateTime,
    required this.subscribedCount,
    required this.specialType,
    required this.updateTime,
    required this.coverImgUrl,
    required this.coverImgId,
    required this.trackCount,
    required this.commentThreadId,
    required this.trackUpdateTime,
    required this.playCount,
    required this.createTime,
    required this.ordered,
    required this.description,
    required this.status,
    required this.tags,
    required this.userId,
    required this.id,
    required this.name,
    required this.tracks,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'updateFrequency': updateFrequency,
      'trackNumberUpdateTime': trackNumberUpdateTime,
      'subscribedCount': subscribedCount,
      'specialType': specialType,
      'updateTime': updateTime,
      'coverImgUrl': coverImgUrl,
      'coverImgId': coverImgId,
      'trackCount': trackCount,
      'commentThreadId': commentThreadId,
      'trackUpdateTime': trackUpdateTime,
      'playCount': playCount,
      'createTime': createTime,
      'ordered': ordered,
      'description': description,
      'status': status,
      'tags': tags,
      'userId': userId,
      'id': id,
      'name': name,
      'tracks': tracks.map((x) => x.toMap()).toList(),
    };
  }

  factory Toplist.fromMap(Map<String, dynamic> map) {
    return Toplist(
      updateFrequency: map['updateFrequency'] as String,
      trackNumberUpdateTime: map['trackNumberUpdateTime'] as int,
      subscribedCount: map['subscribedCount'] as int,
      specialType: map['specialType'] as int,
      updateTime: map['updateTime'] as int,
      coverImgUrl: map['coverImgUrl'] as int,
      coverImgId: map['coverImgId'] as int,
      trackCount: map['trackCount'] as int,
      commentThreadId: map['commentThreadId'] as String,
      trackUpdateTime: map['trackUpdateTime'] as int,
      playCount: map['playCount'] as int,
      createTime: map['createTime'] as int,
      ordered: map['ordered'] as bool,
      description: map['description'] as String,
      status: map['status'] as int,
      tags: map['tags'] == null
          ? []
          : List<String>.from((map['tags'] as List<dynamic>)),
      userId: map['userId'] as int,
      id: map['id'] as int,
      name: map['name'] as String,
      tracks: List<ToplistSong>.from(
        (map['tracks'] as List<int>).map<ToplistSong>(
          (x) => ToplistSong.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Toplist.fromJson(String source) =>
      Toplist.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ToplistSong {
  final String first;
  final String second;
  ToplistSong({
    required this.first,
    required this.second,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'first': first,
      'second': second,
    };
  }

  factory ToplistSong.fromMap(Map<String, dynamic> map) {
    return ToplistSong(
      first: map['first'] as String,
      second: map['second'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ToplistSong.fromJson(String source) =>
      ToplistSong.fromMap(json.decode(source) as Map<String, dynamic>);
}
