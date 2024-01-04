import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/responses/cloud/user_cloud_response.dart';

class CloudUploadResponse extends BaseResponse {
  final String songId;
  final bool needUpload;
  final PrivateCloud? privateCloud;
  CloudUploadResponse({
    required super.code,
    super.msg,
    this.songId = '',
    this.needUpload = false,
    this.privateCloud,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'songId': songId,
        'needUpload': needUpload,
        'privateCloud': privateCloud?.toMap(),
      });
  }

  factory CloudUploadResponse.fromMap(Map<String, dynamic> map) {
    final superMap = BaseResponse.fromMap(map);
    return CloudUploadResponse(
      code: superMap.code,
      msg: superMap.msg,
      songId: (map['songId'] as String?) ?? '',
      needUpload: (map['needUpload'] as bool?) ?? false,
      privateCloud: map['privateCloud'] != null
          ? PrivateCloud.fromMap(map['privateCloud'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory CloudUploadResponse.fromJson(String source) =>
      CloudUploadResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
