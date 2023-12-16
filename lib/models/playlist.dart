import 'dart:convert';

import 'package:get/get.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/models/user_profile.dart';

class Playlist {
  final int id;
  final String name;
  final String coverImgUrl;
  final String? description;
  final int playCount;
  final int trackCount;
  final int commentCount;
  final int shareCount;
  final int subscribedCount;
  final RxBool subscribed = false.obs;
  final List<Track> tracks;
  final UserProfile? creator;

  Playlist({
    required this.id,
    required this.name,
    required this.coverImgUrl,
    this.description,
    required this.playCount,
    this.tracks = const [],
    required this.trackCount,
    required this.commentCount,
    required this.shareCount,
    required this.subscribedCount,
    this.creator,
    bool subscribed = false,
  }) {
    this.subscribed.value = subscribed;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'coverImgUrl': coverImgUrl,
      'description': description,
      'playCount': playCount,
      'tracks': tracks.map((x) => x.toMap()).toList(),
      'trackCount': trackCount,
      'commentCount': commentCount,
      'shareCount': shareCount,
      'subscribedCount': subscribedCount,
      'creator': creator?.toMap(),
      'subscribed': subscribed.value,
    };
  }

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'] as int,
      name: map['name'] as String,
      coverImgUrl: map['coverImgUrl'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      playCount: map['playCount'] as int,
      trackCount: (map['trackCount'] as int?) ?? 0,
      commentCount: (map['commentCount'] as int?) ?? 0,
      shareCount: (map['shareCount'] as int?) ?? 0,
      subscribedCount: (map['subscribedCount'] as int?) ?? 0,
      tracks: map['tracks'] != null
          ? List<Track>.from(
              (map['tracks'] as List<dynamic>).map<Track?>(
                (x) => Track.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      creator: map['creator'] != null
          ? UserProfile.fromMap(map['creator'] as Map<String, dynamic>)
          : null,
      subscribed: (map['subscribed'] as bool?) ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Playlist.fromJson(String source) =>
      Playlist.fromMap(json.decode(source) as Map<String, dynamic>);
}
