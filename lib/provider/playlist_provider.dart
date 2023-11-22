import 'package:qianshi_music/models/responses/playlist_catlist_response.dart';
import 'package:qianshi_music/utils/http/http_util.dart';

class PlaylistProvider {
  static Future<dynamic> getPlaylistDetail(int id) async {
    return HttpUtils.get<dynamic>('playlist/detail?id=$id');
  }

  static Future<PlaylistCatlistResponse> getPlaylistCatlist() async {
    final response = await HttpUtils.get<dynamic>('playlist/catlist');
    return PlaylistCatlistResponse.fromMap(response.data);
  }
}
