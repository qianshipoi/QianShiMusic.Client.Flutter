import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/responses/cloud/cloud_upload_response.dart';
import 'package:qianshi_music/models/responses/cloud/user_cloud_detail_response.dart';
import 'package:qianshi_music/models/responses/cloud/user_cloud_response.dart';
import 'package:qianshi_music/models/responses/user_detail_respinse.dart';
import 'package:qianshi_music/models/responses/user_followeds_response.dart';
import 'package:qianshi_music/models/responses/user_follows_response.dart';
import 'package:qianshi_music/models/responses/user_playlist_response.dart';
import 'package:qianshi_music/provider/index.dart';
import 'package:qianshi_music/utils/http/http_util.dart';

class UserProvider {
  static Future<UserPlaylistResponse> playlist(int uid,
      {bool noCache = false}) async {
    return UserPlaylistResponse.fromMap(await requestGet(
      'user/playlist',
      query: {
        'uid': uid,
      }..addIf(noCache, "t", DateTime.now().millisecondsSinceEpoch),
    ));
  }

  static Future<UserDetailRespinse> detail(int uid) async {
    return UserDetailRespinse.fromMap(await requestGet('user/detail?uid=$uid'));
  }

  static Future<UserFollowsResponse> follows(int uid,
      {int limit = 30, int offset = 0}) async {
    return UserFollowsResponse.fromMap(await requestGet('user/follows', query: {
      'uid': uid,
      'limit': limit,
      'offset': offset,
    }));
  }

  static Future<UserFollowedsResponse> followeds(int uid,
      {int limit = 30, int offset = 0}) async {
    return UserFollowedsResponse.fromMap(
        await requestGet('user/followeds', query: {
      'uid': uid,
      'limit': limit,
      'offset': offset,
    }));
  }

  static Future<UserCloudResponse> cloud(
          {int limit = 30, int offset = 0}) async =>
      UserCloudResponse.fromMap(await requestGet('user/cloud', query: {
        'limit': limit,
        'offset': offset,
      }));

  static Future<UserCloudDetailResponse> cloudDetail(List<int> ids) async =>
      UserCloudDetailResponse.fromMap(
          await requestGet('user/cloud/detail', query: {
        'id': ids.join(','),
      }));

  static Future<BaseResponse> cloudDel(List<int> ids) async =>
      BaseResponse.fromMap(
          await requestGet('user/cloud/del', query: {'id': ids.join(',')}));

  static Future<CloudUploadResponse> cloudAdd(File mucicFile) async {
    final response = await HttpUtils.post("cloud",
        data: dio.FormData.fromMap({
          'songFile': dio.MultipartFile.fromString(mucicFile.path),
        }),
        params: {
          't': DateTime.now().millisecondsSinceEpoch,
        });

    return CloudUploadResponse.fromMap(formatResponse(response));
  }
}
