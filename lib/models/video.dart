import 'dart:convert';

class VideoCreator {
  final int userId;
  final String userName;
  VideoCreator({
    required this.userId,
    required this.userName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'userName': userName,
    };
  }

  factory VideoCreator.fromMap(Map<String, dynamic> map) {
    return VideoCreator(
      userId: map['userId'] as int,
      userName: map['userName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoCreator.fromJson(String source) =>
      VideoCreator.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Video {
  final String vid;
  final String coverUrl;
  final String title;
  final int durationms;
  final int playTime;
  final int type;
  final List<VideoCreator> creator;
  Video({
    required this.vid,
    required this.coverUrl,
    required this.title,
    required this.durationms,
    required this.playTime,
    required this.type,
    required this.creator,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'vid': vid,
      'coverUrl': coverUrl,
      'title': title,
      'durationms': durationms,
      'playTime': playTime,
      'type': type,
      'creator': creator.map((e) => e.toMap()).toList(),
    };
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      vid: map['vid'] as String,
      coverUrl: map['coverUrl'] as String,
      title: map['title'] as String,
      durationms: map['durationms'] as int,
      playTime: map['playTime'] as int,
      type: map['type'] as int,
      creator: (map['creator'] as List<dynamic>)
          .map((e) => VideoCreator.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Video.fromJson(String source) =>
      Video.fromMap(json.decode(source) as Map<String, dynamic>);
}
