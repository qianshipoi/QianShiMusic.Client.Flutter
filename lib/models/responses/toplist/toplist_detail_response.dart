import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/toplist.dart';
import 'package:qianshi_music/models/track.dart';

class ToplistDetailResponse extends BaseResponse {
  final List<Toplist> list;
  final ToplistArtistTopList? artistToplist;
  final ToplistRewardToplist? rewardToplist;
  ToplistDetailResponse({
    required super.code,
    super.msg,
    this.list = const [],
    this.artistToplist,
    this.rewardToplist,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll(<String, dynamic>{
        'list': list.map((x) => x.toMap()).toList(),
        'artistToplist': artistToplist?.toMap(),
        'rewardToplist': rewardToplist?.toMap(),
      });
  }

  factory ToplistDetailResponse.fromMap(Map<String, dynamic> map) {
    final superResponse = BaseResponse.fromMap(map);
    return ToplistDetailResponse(
      code: superResponse.code,
      msg: superResponse.msg,
      list: map['list'] == null
          ? []
          : List<Toplist>.from(
              (map['list'] as List<dynamic>).map<Toplist>(
                (x) => Toplist.fromMap(x as Map<String, dynamic>),
              ),
            ),
      artistToplist: map['artistToplist'] != null
          ? ToplistArtistTopList.fromMap(
              map['artistToplist'] as Map<String, dynamic>)
          : null,
      rewardToplist: map['rewardToplist'] != null
          ? ToplistRewardToplist.fromMap(
              map['rewardToplist'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory ToplistDetailResponse.fromJson(String source) =>
      ToplistDetailResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class ToplistArtist {
  final String first;
  final String second;
  final int third;
  ToplistArtist({
    required this.first,
    required this.second,
    required this.third,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'first': first,
      'second': second,
      'third': third,
    };
  }

  factory ToplistArtist.fromMap(Map<String, dynamic> map) {
    return ToplistArtist(
      first: map['first'] as String,
      second: map['second'] as String,
      third: map['third'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ToplistArtist.fromJson(String source) =>
      ToplistArtist.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ToplistArtistTopList {
  final String coverUrl;
  final List<ToplistArtist> artists;
  final String name;
  final String upateFrequency;
  final int position;
  final String updateFrequency;
  ToplistArtistTopList({
    required this.coverUrl,
    required this.artists,
    required this.name,
    required this.upateFrequency,
    required this.position,
    required this.updateFrequency,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'coverUrl': coverUrl,
      'artists': artists.map((x) => x.toMap()).toList(),
      'name': name,
      'upateFrequency': upateFrequency,
      'position': position,
      'updateFrequency': updateFrequency,
    };
  }

  factory ToplistArtistTopList.fromMap(Map<String, dynamic> map) {
    return ToplistArtistTopList(
      coverUrl: map['coverUrl'] as String,
      artists: map['artists'] == null
          ? []
          : List<ToplistArtist>.from(
              (map['artists'] as List<dynamic>).map<ToplistArtist>(
                (x) => ToplistArtist.fromMap(x as Map<String, dynamic>),
              ),
            ),
      name: map['name'] as String,
      upateFrequency: map['upateFrequency'] as String,
      position: map['position'] as int,
      updateFrequency: map['updateFrequency'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ToplistArtistTopList.fromJson(String source) =>
      ToplistArtistTopList.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ToplistRewardToplist {
  final String coverUrl;
  final String name;
  final int position;
  final List<Track> songs;
  ToplistRewardToplist({
    required this.coverUrl,
    required this.name,
    required this.position,
    required this.songs,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'coverUrl': coverUrl,
      'name': name,
      'position': position,
      'songs': songs.map((x) => x.toMap()).toList(),
    };
  }

  factory ToplistRewardToplist.fromMap(Map<String, dynamic> map) {
    return ToplistRewardToplist(
      coverUrl: map['coverUrl'] as String,
      name: map['name'] as String,
      position: map['position'] as int,
      songs: map['songs'] == null
          ? []
          : List<Track>.from(
              (map['songs'] as List<dynamic>).map<Track>(
                (x) => Track.fromMap(x as Map<String, dynamic>),
              ),
            ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ToplistRewardToplist.fromJson(String source) =>
      ToplistRewardToplist.fromMap(json.decode(source) as Map<String, dynamic>);
}
