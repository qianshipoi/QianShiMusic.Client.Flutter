import 'dart:convert';

import 'package:qianshi_music/models/responses/base_response.dart';

class MvUrlResponse extends BaseResponse {
  final MvUrlData? data;

  MvUrlResponse({
    this.data,
    required super.code,
    super.msg,
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'data': data?.toMap(),
      });
  }

  factory MvUrlResponse.fromMap(Map<String, dynamic> map) {
    final base = BaseResponse.fromMap(map);
    return MvUrlResponse(
      code: base.code,
      msg: base.msg,
      data: map['data'] != null
          ? MvUrlData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory MvUrlResponse.fromJson(String source) =>
      MvUrlResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}

class MvUrlData {
  final int id;
  final String url;
  final int r;
  final int size;
  final String md5;
  final int expi;
  final int fee;
  final int mvFee;
  MvUrlData({
    required this.id,
    required this.url,
    required this.r,
    required this.size,
    required this.md5,
    required this.expi,
    required this.fee,
    required this.mvFee,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'url': url,
      'r': r,
      'size': size,
      'md5': md5,
      'expi': expi,
      'fee': fee,
      'mvFee': mvFee,
    };
  }

  factory MvUrlData.fromMap(Map<String, dynamic> map) {
    return MvUrlData(
      id: map['id'] as int,
      url: map['url'] as String,
      r: map['r'] as int,
      size: map['size'] as int,
      md5: map['md5'] as String,
      expi: map['expi'] as int,
      fee: map['fee'] as int,
      mvFee: map['mvFee'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory MvUrlData.fromJson(String source) =>
      MvUrlData.fromMap(json.decode(source) as Map<String, dynamic>);
}
