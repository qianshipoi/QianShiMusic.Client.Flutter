import 'dart:convert';

import 'package:qianshi_music/models/artist.dart';

class Album {
  final int id;
  final String name;
  final String? picUrl;
  final Artist? artist;
  final List<Artist>? artists;
  final String? containedSong;
  final List<String>? alias;
  Album({
    required this.id,
    required this.name,
    this.picUrl,
    this.artist,
    this.artists,
    this.containedSong,
    this.alias,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'picUrl': picUrl,
      'artist': artist?.toMap(),
      'artists': artists?.map((x) => x.toMap()).toList(),
      'containedSong': containedSong,
      'alias': alias,
    };
  }

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      id: map['id'] as int,
      name: map['name'] as String,
      picUrl: map['picUrl'] != null ? map['picUrl'] as String : null,
      artist: map['artist'] != null
          ? Artist.fromMap(map['artist'] as Map<String, dynamic>)
          : null,
      artists: map['artists'] != null
          ? List<Artist>.from(
              (map['artists'] as List<dynamic>).map<Artist?>(
                (x) => Artist.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      containedSong:
          map['containedSong'] != null ? map['containedSong'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Album.fromJson(String source) =>
      Album.fromMap(json.decode(source) as Map<String, dynamic>);
}
