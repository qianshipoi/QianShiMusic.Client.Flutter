// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:qianshi_music/models/artist.dart';

class Mv {
  final int id;
  final String cover;
  final String name;
  final int playCount;
  final int duration;
  final int artistId;
  final String artistName;
  final String briefDesc;
  final List<Artist> artists;
  final List<VideoGroupItem> videoGroup;
  Mv({
    required this.id,
    required this.cover,
    required this.name,
    required this.playCount,
    required this.duration,
    required this.artistName,
    required this.artistId,
    required this.briefDesc,
    this.artists = const [],
    this.videoGroup = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'cover': cover,
      'name': name,
      'playCount': playCount,
      'duration': duration,
      'artistName': artistName,
      'artistId': artistId,
      'briefDesc': briefDesc,
      'artists': artists.map((e) => e.toMap()).toList(),
      'videoGroup': videoGroup.map((e) => e.toMap()).toList(),
    };
  }

  factory Mv.fromMap(Map<String, dynamic> map) {
    return Mv(
      id: map['id'] as int,
      cover: map['cover'] as String,
      name: map['name'] as String,
      playCount: map['playCount'] as int,
      duration: map['duration'] as int,
      artistName: map['artistName'] as String,
      artistId: map['artistId'] as int,
      briefDesc: (map['briefDesc'] as String?) ?? '',
      artists: (map['artists'] as List<dynamic>?)
              ?.map((e) => Artist.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      videoGroup: (map['videoGroup'] as List<dynamic>?)
              ?.map((e) => VideoGroupItem.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Mv.fromJson(String source) =>
      Mv.fromMap(json.decode(source) as Map<String, dynamic>);
}

class VideoGroupItem {
  final int id;
  final String name;
  final int type;
  VideoGroupItem({
    required this.id,
    required this.name,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type,
    };
  }

  factory VideoGroupItem.fromMap(Map<String, dynamic> map) {
    return VideoGroupItem(
      id: map['id'] as int,
      name: map['name'] as String,
      type: map['type'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory VideoGroupItem.fromJson(String source) =>
      VideoGroupItem.fromMap(json.decode(source) as Map<String, dynamic>);
}
