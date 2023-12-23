import 'package:get/get.dart';
import 'package:qianshi_music/models/responses/user_followeds_response.dart';
import 'package:qianshi_music/models/responses/user_follows_response.dart';
import 'package:qianshi_music/models/responses/user_playlist_response.dart';
import 'package:qianshi_music/provider/index.dart';

import '../models/responses/user_detail_respinse.dart';

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
}
