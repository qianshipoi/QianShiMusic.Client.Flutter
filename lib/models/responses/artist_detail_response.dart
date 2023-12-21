import 'dart:convert';

import 'package:qianshi_music/models/artist.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class ArtistDetailResponse extends BaseResponse {
  final ArtistDetailResponseData? data;
  ArtistDetailResponse({
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

  factory ArtistDetailResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return ArtistDetailResponse(
      code: base.code,
      msg: base.msg,
      data: map['data'] != null
          ? ArtistDetailResponseData.fromMap(
              map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory ArtistDetailResponse.fromJson(String source) =>
      ArtistDetailResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ArtistDetailResponseData {
  final int videoCount;
  final Artist artist;
  final bool blacklist;
  final int preferShow;
  final bool showPriMsg;
  final List<ExpertIdentiy> secondaryExpertIdentiy;
  ArtistDetailResponseData({
    required this.videoCount,
    required this.artist,
    required this.blacklist,
    required this.preferShow,
    required this.showPriMsg,
    required this.secondaryExpertIdentiy,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'videoCount': videoCount,
      'artist': artist.toMap(),
      'blacklist': blacklist,
      'preferShow': preferShow,
      'showPriMsg': showPriMsg,
      'secondaryExpertIdentiy':
          secondaryExpertIdentiy.map((x) => x.toMap()).toList(),
    };
  }

  factory ArtistDetailResponseData.fromMap(Map<String, dynamic> map) {
    return ArtistDetailResponseData(
      videoCount: map['videoCount'] as int,
      artist: Artist.fromMap(map['artist'] as Map<String, dynamic>),
      blacklist: map['blacklist'] as bool,
      preferShow: map['preferShow'] as int,
      showPriMsg: map['showPriMsg'] as bool,
      secondaryExpertIdentiy: map['secondaryExpertIdentiy'] == null
          ? []
          : List<ExpertIdentiy>.from(
              (map['secondaryExpertIdentiy'] as List<dynamic>)
                  .map<ExpertIdentiy>(
                (x) => ExpertIdentiy.fromMap(x as Map<String, dynamic>),
              ),
            ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ArtistDetailResponseData.fromJson(String source) =>
      ArtistDetailResponseData.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class ExpertIdentiy {
  final int expertIdentiyId;
  final String expertIdentiyName;
  final int expertIdentiyCount;
  ExpertIdentiy({
    required this.expertIdentiyId,
    required this.expertIdentiyName,
    required this.expertIdentiyCount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'expertIdentiyId': expertIdentiyId,
      'expertIdentiyName': expertIdentiyName,
      'expertIdentiyCount': expertIdentiyCount,
    };
  }

  factory ExpertIdentiy.fromMap(Map<String, dynamic> map) {
    return ExpertIdentiy(
      expertIdentiyId: map['expertIdentiyId'] as int,
      expertIdentiyName: map['expertIdentiyName'] as String,
      expertIdentiyCount: map['expertIdentiyCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpertIdentiy.fromJson(String source) =>
      ExpertIdentiy.fromMap(json.decode(source) as Map<String, dynamic>);
}
