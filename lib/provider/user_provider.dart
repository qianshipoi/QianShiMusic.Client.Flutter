import 'package:qianshi_music/models/responses/user_playlist_response.dart';
import 'package:qianshi_music/utils/http/http_util.dart';

class UserProvider {
  static Future<UserPlaylistResponse> playlist(int uid) async {
    final response = await HttpUtils.get<dynamic>('user/playlist?uid=$uid');
    if (response.statusCode == 200) {
      return UserPlaylistResponse.fromMap(response.data);
    } else {
      return UserPlaylistResponse(code: -1, msg: "网络异常");
    }
  }
}
