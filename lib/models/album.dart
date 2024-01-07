import 'dart:convert';

import 'package:qianshi_music/models/artist.dart';

class Album {
  final int id;
  final String name;
  final String? picUrl;
  final Artist? artist;
  final List<Artist> artists;
  final String? containedSong;
  final List<String>? alias;
  final String? description;
  final int size;
  final String company;
  Album({
    required this.id,
    required this.name,
    this.picUrl,
    this.artist,
    this.artists = const [],
    this.containedSong,
    this.alias,
    this.description,
    this.size = 0,
    this.company = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'picUrl': picUrl,
      'artist': artist?.toMap(),
      'artists': artists.map((x) => x.toMap()).toList(),
      'containedSong': containedSong,
      'alias': alias,
      'description': description,
      'size': size,
      'company': company,
    };
  }

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      id: map['id'] as int,
      name: (map['name'] as String?)??'',
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
          : [],
      containedSong:
          map['containedSong'] != null ? map['containedSong'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      size: map['size'] != null ? map['size'] as int : 0,
      company: map['company'] != null ? map['company'] as String : '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Album.fromJson(String source) =>
      Album.fromMap(json.decode(source) as Map<String, dynamic>);
}
