import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/user_profile.dart';

class RecordRecentResponse extends BaseResponse {
  final RecordRecentData? data;
  RecordRecentResponse({
    required super.code,
    super.msg,
    this.data,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'data': data?.toMap(),
      });
  }

  factory RecordRecentResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return RecordRecentResponse(
      code: base.code,
      msg: base.msg,
      data: map['data'] != null
          ? RecordRecentData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory RecordRecentResponse.fromJson(String source) =>
      RecordRecentResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class RecordRecentData {
  final int total;
  final List<RecordRecent> list;
  RecordRecentData({
    required this.total,
    required this.list,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total': total,
      'list': list.map((x) => x.toMap()).toList(),
    };
  }

  factory RecordRecentData.fromMap(Map<String, dynamic> map) {
    return RecordRecentData(
      total: (map['total'] as int?) ?? 0,
      list: map['list'] == null
          ? []
          : List<RecordRecent>.from(
              (map['list'] as List<dynamic>).map<RecordRecent>(
                (x) => RecordRecent.fromMap(x as Map<String, dynamic>),
              ),
            ),
    );
  }

  String toJson() => json.encode(toMap());

  factory RecordRecentData.fromJson(String source) =>
      RecordRecentData.fromMap(json.decode(source) as Map<String, dynamic>);
}

class RecordRecent {
  static String songType = "SONG";
  static String mlogTyoe = "MLOG";
  static String mvType = "MV";
  static String albumType = "ALBUM";
  static String playlistType = "PLAYLIST";

  final String resourceId;
  final int playTime;
  final String resourceType;
  final String? os;
  final bool? banned;
  final dynamic data;
  RecordRecent({
    required this.resourceId,
    required this.playTime,
    required this.resourceType,
    this.os,
    this.banned,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'resourceId': resourceId,
      'playTime': playTime,
      'resourceType': resourceType,
      'os': os,
      'banned': banned,
      'data': data,
    };
  }

  factory RecordRecent.fromMap(Map<String, dynamic> map) {
    return RecordRecent(
      resourceId: map['resourceId'] as String,
      playTime: map['playTime'] as int,
      resourceType: map['resourceType'] as String,
      os: map['os'] != null ? map['os'] as String : null,
      banned: map['banned'] != null ? map['banned'] as bool : null,
      data: map['data'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecordRecent.fromJson(String source) =>
      RecordRecent.fromMap(json.decode(source) as Map<String, dynamic>);
}

class RecordRecentMlog {
  final String id;
  final String title;
  final String coverUrl;
  final int duration;
  final UserProfile creator;
  RecordRecentMlog({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.duration,
    required this.creator,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'coverUrl': coverUrl,
      'duration': duration,
      'creator': creator.toMap(),
    };
  }

  factory RecordRecentMlog.fromMap(Map<String, dynamic> map) {
    return RecordRecentMlog(
      id: map['id'] as String,
      title: map['title'] as String,
      coverUrl: map['coverUrl'] as String,
      duration: map['duration'] as int,
      creator: UserProfile.fromMap(map['creator'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory RecordRecentMlog.fromJson(String source) =>
      RecordRecentMlog.fromMap(json.decode(source) as Map<String, dynamic>);
}

class RecordRecentMv {
  final String id;
  final String name;
  final String coverUrl;
  final int duration;
  final List<RecordRecentMvArtist> artists;
  RecordRecentMv({
    required this.id,
    required this.name,
    required this.coverUrl,
    required this.duration,
    required this.artists,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'coverUrl': coverUrl,
      'duration': duration,
      'artists': artists.map((x) => x.toMap()).toList(),
    };
  }

  factory RecordRecentMv.fromMap(Map<String, dynamic> map) {
    return RecordRecentMv(
      id: map['id'] as String,
      name: map['name'] as String,
      coverUrl: map['coverUrl'] as String,
      duration: map['duration'] as int,
      artists: List<RecordRecentMvArtist>.from(
        (map['artists'] as List<dynamic>).map<RecordRecentMvArtist>(
          (x) => RecordRecentMvArtist.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory RecordRecentMv.fromJson(String source) =>
      RecordRecentMv.fromMap(json.decode(source) as Map<String, dynamic>);
}

class RecordRecentMvArtist {
  final int id;
  final String name;
  RecordRecentMvArtist({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory RecordRecentMvArtist.fromMap(Map<String, dynamic> map) {
    return RecordRecentMvArtist(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecordRecentMvArtist.fromJson(String source) =>
      RecordRecentMvArtist.fromMap(json.decode(source) as Map<String, dynamic>);
}
