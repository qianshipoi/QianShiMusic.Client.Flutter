import 'dart:convert';

import 'package:qianshi_music/models/album.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class UserCloudResponse extends BaseResponse {
  final int count;
  final String size;
  final String maxSize;
  final bool hasMore;
  final List<PrivateCloud> data;

  UserCloudResponse({
    required super.code,
    super.msg,
    this.count = 0,
    this.size = "0",
    this.maxSize = "0",
    this.hasMore = false,
    this.data = const [],
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'count': count,
        'size': size,
        'maxSize': maxSize,
        'hasMore': hasMore,
        'data': data.map((x) => x.toMap()).toList(),
      });
  }

  factory UserCloudResponse.fromMap(Map<String, dynamic> map) {
    final superMap = BaseResponse.fromMap(map);
    return UserCloudResponse(
      code: superMap.code,
      msg: superMap.msg,
      count: (map['count'] as int?) ?? 0,
      size: (map['size'] as String?) ?? "0",
      maxSize: (map['maxSize'] as String?) ?? "0",
      hasMore: (map['hasMore'] as bool?) ?? false,
      data: map['data'] == null
          ? []
          : List<PrivateCloud>.from(
              (map['data'] as List<dynamic>).map<PrivateCloud>(
                (x) => PrivateCloud.fromMap(x as Map<String, dynamic>),
              ),
            ),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory UserCloudResponse.fromJson(String source) =>
      UserCloudResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class PrivateCloud {
  final SimpleSong simpleSong;
  final String album;
  final String artist;
  final int bitrate;
  final int songId;
  final int addTime;
  final String songName;
  final int version;
  final int fileSize;
  final String fileName;

  PrivateCloud({
    required this.simpleSong,
    required this.album,
    required this.artist,
    required this.bitrate,
    required this.songId,
    required this.addTime,
    required this.songName,
    required this.version,
    required this.fileSize,
    required this.fileName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'simpleSong': simpleSong.toMap(),
      'album': album,
      'artist': artist,
      'bitrate': bitrate,
      'songId': songId,
      'addTime': addTime,
      'songName': songName,
      'version': version,
      'fileSize': fileSize,
      'fileName': fileName,
    };
  }

  factory PrivateCloud.fromMap(Map<String, dynamic> map) {
    return PrivateCloud(
      simpleSong: SimpleSong.fromMap(map['simpleSong'] as Map<String, dynamic>),
      album: map['album'] as String,
      artist: map['artist'] as String,
      bitrate: map['bitrate'] as int,
      songId: map['songId'] as int,
      addTime: map['addTime'] as int,
      songName: map['songName'] as String,
      version: map['version'] as int,
      fileSize: map['fileSize'] as int,
      fileName: map['fileName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PrivateCloud.fromJson(String source) =>
      PrivateCloud.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SimpleSong {
  final int id;
  final String name;
  final int fee;
  final Album? album;
  final List<SimpleSongArtist> artists;
  final int dt;
  final int mv;

  SimpleSong({
    required this.id,
    required this.name,
    required this.fee,
    required this.album,
    required this.artists,
    required this.dt,
    required this.mv,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'fee': fee,
      'album': album?.toMap(),
      'artists': artists.map((x) => x.toMap()).toList(),
      'dt': dt,
      'mv': mv,
    };
  }

  factory SimpleSong.fromMap(Map<String, dynamic> map) {
    return SimpleSong(
      id: map['id'] as int,
      name: (map['name'] as String?) ?? "",
      fee: (map['fee'] as int?) ?? 0,
      album: map['al'] != null
          ? Album.fromMap(map['al'] as Map<String, dynamic>)
          : null,
      artists: map['ar'] == null
          ? []
          : List<SimpleSongArtist>.from(
              (map['ar'] as List<dynamic>).map<SimpleSongArtist>(
                (x) => SimpleSongArtist.fromMap(x as Map<String, dynamic>),
              ),
            ),
      dt: (map['dt'] as int?) ?? 0,
      mv: (map['mv'] as int?) ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SimpleSong.fromJson(String source) =>
      SimpleSong.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SimpleSongArtist {
  final int id;
  final String name;
  final List<String> tns;
  final List<String> alias;

  SimpleSongArtist({
    required this.id,
    required this.name,
    required this.tns,
    required this.alias,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'tns': tns,
      'alias': alias,
    };
  }

  factory SimpleSongArtist.fromMap(Map<String, dynamic> map) {
    return SimpleSongArtist(
      id: map['id'] as int,
      name: map['name'] as String,
      tns: map['tns'] == null
          ? []
          : List<String>.from((map['tns'] as List<dynamic>)),
      alias: map['alias'] == null
          ? []
          : List<String>.from((map['alias'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory SimpleSongArtist.fromJson(String source) =>
      SimpleSongArtist.fromMap(json.decode(source) as Map<String, dynamic>);
}
