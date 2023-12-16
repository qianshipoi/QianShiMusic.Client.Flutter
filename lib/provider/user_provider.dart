import 'package:get/get.dart';
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
}
