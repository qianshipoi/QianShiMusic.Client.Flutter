import 'dart:convert';

import 'package:get/get.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/models/user_profile.dart';

class Playlist {
  final int id;
  final RxString name = ''.obs;
  final RxString coverImgUrl = ''.obs;
  final Rx<String?> description = Rx<String?>(null);
  final int playCount;
  final RxInt trackCount = 0.obs;
  final int commentCount;
  final int shareCount;
  final int subscribedCount;
  final RxBool subscribed = false.obs;
  final List<Track> tracks;
  final UserProfile? creator;
  final RxList<String> tags = <String>[].obs;

  Playlist({
    required this.id,
    required String name,
    required String coverImgUrl,
    String? description,
    required this.playCount,
    this.tracks = const [],
    required int trackCount,
    required this.commentCount,
    required this.shareCount,
    required this.subscribedCount,
    this.creator,
    bool subscribed = false,
    List<String> tags = const [],
  }) {
    this.subscribed.value = subscribed;
    this.name.value = name;
    this.coverImgUrl.value = coverImgUrl;
    this.description.value = description;
    this.tags.value = tags;
    this.trackCount.value = trackCount;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name.value,
      'coverImgUrl': coverImgUrl.value,
      'description': description.value,
      'playCount': playCount,
      'tracks': tracks.map((x) => x.toMap()).toList(),
      'trackCount': trackCount.value,
      'commentCount': commentCount,
      'shareCount': shareCount,
      'subscribedCount': subscribedCount,
      'creator': creator?.toMap(),
      'subscribed': subscribed.value,
      'tags': tags.toList(),
    };
  }

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'] as int,
      name: map['name'] as String,
      coverImgUrl: (map['coverImgUrl'] ?? map['picUrl']) as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      playCount: ((map['playCount'] ?? map['playcount']) as int?) ?? 0,
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
      tags: map['tags'] != null
          ? List<String>.from(
              (map['tags'] as List<dynamic>).map((e) => e.toString()))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Playlist.fromJson(String source) =>
      Playlist.fromMap(json.decode(source) as Map<String, dynamic>);
}
