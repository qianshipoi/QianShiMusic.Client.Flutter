import 'dart:convert';

import 'package:qianshi_music/models/artist.dart';

import 'album.dart';

class Track {
  final int id;
  final String name;
  final Album album;
  final List<Artist> artists;
  final int dt;
  Track({
    required this.id,
    required this.name,
    required this.album,
    required this.artists,
    required this.dt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'album': album.toMap(),
      'artists': artists.map((x) => x.toMap()).toList(),
      'dt': dt,
    };
  }

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map['id'] as int,
      name: map['name'] as String,
      album: Album.fromMap((map['album'] ?? map['al']) as Map<String, dynamic>),
      artists: List<Artist>.from(
        ((map['artists'] ?? map['ar']) as List<dynamic>).map<Artist>(
          (x) => Artist.fromMap(x as Map<String, dynamic>),
        ),
      ),
      dt: (map['dt'] ?? map['duration'] ?? 0) as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Track.fromJson(String source) =>
      Track.fromMap(json.decode(source) as Map<String, dynamic>);
}
