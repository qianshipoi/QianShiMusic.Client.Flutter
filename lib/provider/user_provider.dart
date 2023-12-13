import 'package:qianshi_music/models/responses/user_playlist_response.dart';
import 'package:qianshi_music/provider/index.dart';

import '../models/responses/user_detail_respinse.dart';

class UserProvider {
  static Future<UserPlaylistResponse> playlist(int uid) async {
    return UserPlaylistResponse.fromMap(
        await requestGet('user/playlist?uid=$uid'));
  }
  
  static Future<UserDetailRespinse> detail(int uid) async {
    return UserDetailRespinse.fromMap(await requestGet('user/detail?uid=$uid'));
  }
}
