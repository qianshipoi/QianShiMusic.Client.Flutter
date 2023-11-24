import 'dart:convert';

class Video {
  final String vid;
  final String coverUrl;
  final String title;
  final int durationms;
  final int playTime;
  final int type;
  Video({
    required this.vid,
    required this.coverUrl,
    required this.title,
    required this.durationms,
    required this.playTime,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'vid': vid,
      'coverUrl': coverUrl,
      'title': title,
      'durationms': durationms,
      'playTime': playTime,
      'type': type,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory Video.fromJson(String source) =>
      Video.fromMap(json.decode(source) as Map<String, dynamic>);
}
