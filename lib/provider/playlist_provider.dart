import 'package:qianshi_music/models/responses/playlist_catlist_response.dart';
import 'package:qianshi_music/models/responses/playlist_detail_response.dart';
import 'package:qianshi_music/models/responses/playlist_top_response.dart';
import 'package:qianshi_music/models/responses/playlist_track_all_response.dart';
import 'package:qianshi_music/provider/index.dart';

class PlaylistProvider {
  static Future<PlaylistDetailResponse> detail(int id) async {
    return PlaylistDetailResponse.fromMap(
        await requestGet('playlist/detail?id=$id'));
  }

  static Future<PlaylistCatlistResponse> catlist() async {
    return PlaylistCatlistResponse.fromMap(
        await requestGet('playlist/catlist'));
  }

  static Future<PlaylistTopResponse> top(
      {String? cat, int? limit, int? offset, String? order}) async {
    return PlaylistTopResponse.fromMap(await requestGet('top/playlist',
        query: {'cat': cat, 'limit': limit, 'offset': offset, 'order': order}));
  }

  static Future<PlaylistTrackAllResponse> trackAll(
    int id, {
    int limit = 20,
    int offset = 0,
  }) async {
    return PlaylistTrackAllResponse.fromMap(await requestGet(
      'playlist/track/all',
      query: {
        'id': id,
        'limit': limit,
        'offset': offset,
      },
    ));
  }
}
