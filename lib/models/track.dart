import 'dart:convert';

import 'package:qianshi_music/models/artist.dart';

import 'album.dart';

class Track {
  final int id;
  final String name;
  final Album album;
  final List<Artist> artists;
  final int dt;
  final List<String> tns;
  final int mv;
  Track({
    required this.id,
    required this.name,
    required this.album,
    required this.artists,
    required this.dt,
    this.tns = const [],
    this.mv = 0,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'album': album.toMap(),
      'artists': artists.map((x) => x.toMap()).toList(),
      'dt': dt,
      'tns': tns,
      'mv': mv,
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
      tns: map['tns'] == null
          ? []
          : List<String>.from(map['tns'] as List<dynamic>),
      mv: (map['mv'] as int?) ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Track.fromJson(String source) =>
      Track.fromMap(json.decode(source) as Map<String, dynamic>);
}
