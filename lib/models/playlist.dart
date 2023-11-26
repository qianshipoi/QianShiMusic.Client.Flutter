import 'dart:convert';

import 'package:qianshi_music/models/track.dart';

class Playlist {
  final int id;
  final String name;
  final String coverImgUrl;
  final String? description;
  final int playCount;
  final List<Track>? tracks;
  Playlist({
    required this.id,
    required this.name,
    required this.coverImgUrl,
    this.description,
    required this.playCount,
    this.tracks,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'coverImgUrl': coverImgUrl,
      'description': description,
      'playCount': playCount,
      'tracks': tracks?.map((x) => x.toMap()).toList(),
    };
  }

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'] as int,
      name: map['name'] as String,
      coverImgUrl: map['coverImgUrl'] as String,
      description: map['description'] != null ? map['description'] as String : null,
      playCount: map['playCount'] as int,
      tracks: map['tracks'] != null ? List<Track>.from((map['tracks'] as List<dynamic>).map<Track?>((x) => Track.fromMap(x as Map<String,dynamic>),),) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Playlist.fromJson(String source) =>
      Playlist.fromMap(json.decode(source) as Map<String, dynamic>);
}
