import 'dart:convert';

import 'package:qianshi_music/models/artist.dart';

import 'album.dart';

class Track {
  final int id;
  final String name;
  final Album album;
  final List<Artist> artists;
  Track({
    required this.id,
    required this.name,
    required this.album,
    required this.artists,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'album': album.toMap(),
    };
  }

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map['id'] as int,
      name: map['name'] as String,
      album: Album.fromMap((map['al'] ?? map['album']) as Map<String, dynamic>),
      artists: ((map['ar'] ?? map['artists']) as List<dynamic>)
          .map<Artist>((e) => Artist.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Track.fromJson(String source) =>
      Track.fromMap(json.decode(source) as Map<String, dynamic>);
}
