import 'package:qianshi_music/models/responses/playlist_catlist_response.dart';
import 'package:qianshi_music/models/responses/playlist_top_response.dart';
import 'package:qianshi_music/models/responses/playlist_track_all_response.dart';
import 'package:qianshi_music/utils/http/http_util.dart';

class PlaylistProvider {
  static Future<dynamic> getPlaylistDetail(int id) async {
    return HttpUtils.get<dynamic>('playlist/detail?id=$id');
  }

  static Future<PlaylistCatlistResponse> getPlaylistCatlist() async {
    final response = await HttpUtils.get<dynamic>('playlist/catlist');
    return PlaylistCatlistResponse.fromMap(response.data);
  }

  static Future<PlaylistTopResponse> getPlaylistTop(
      {String? cat, int? limit, int? offset, String? order}) async {
    final response = await HttpUtils.get<dynamic>('top/playlist',
        params: {'cat': cat, 'limit': limit, 'offset': offset, 'order': order});
    return PlaylistTopResponse.fromMap(response.data);
  }

  static Future<PlaylistTrackAllResponse> trackAll(int id) async {
    final response = await HttpUtils.get('playlist/track/all?id=$id');
    if (response.statusCode != 200) {
      return PlaylistTrackAllResponse(songs: [], code: -1, msg: "网络异常");
    } else {
      return PlaylistTrackAllResponse.fromMap(response.data);
    }
  }
}
