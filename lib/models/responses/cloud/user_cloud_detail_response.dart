import 'dart:convert';
import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/responses/cloud/user_cloud_response.dart';

class UserCloudDetailResponse extends BaseResponse {
  final List<PrivateCloud> data;
  UserCloudDetailResponse({
    required super.code,
    super.msg,
    this.data = const [],
  });

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'data': data.map((x) => x.toMap()).toList(),
      });
  }

  factory UserCloudDetailResponse.fromMap(Map<String, dynamic> map) {
    final superMap = BaseResponse.fromMap(map);
    return UserCloudDetailResponse(
      code: superMap.code,
      msg: superMap.msg,
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

  factory UserCloudDetailResponse.fromJson(String source) =>
      UserCloudDetailResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
