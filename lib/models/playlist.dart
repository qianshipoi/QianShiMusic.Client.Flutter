import 'dart:convert';

import 'package:qianshi_music/models/track.dart';

class Playlist {
  final int id;
  final String name;
  final String coverImgUrl;
  final String description;
  final int playCount;
  final List<Track> tracks;
  Playlist({
    required this.id,
    required this.name,
    required this.coverImgUrl,
    required this.description,
    required this.playCount,
    required this.tracks,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'coverImgUrl': coverImgUrl,
      'description': description,
      'playCount': playCount,
      'tracks': tracks.map((x) => x.toMap()).toList(),
    };
  }

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'] as int,
      name: map['name'] as String,
      coverImgUrl: map['coverImgUrl'] as String,
      description: map['description'] as String,
      playCount: map['playCount'] as int,
      tracks: (map.containsKey('tracks') && map['tracks'] != null)
          ? List<Map<String, dynamic>>.from(map['tracks'])
              .map((e) => Track.fromMap(e))
              .toList()
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Playlist.fromJson(String source) =>
      Playlist.fromMap(json.decode(source) as Map<String, dynamic>);
}
