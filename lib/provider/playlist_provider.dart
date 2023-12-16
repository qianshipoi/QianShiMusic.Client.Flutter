import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/responses/playlist_catlist_response.dart';
import 'package:qianshi_music/models/responses/playlist_create_resppnse.dart';
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

  static Future<PlaylistCreateResponse> create(String name,
      {bool privacy = false, String type = 'NORMAL'}) async {
    return PlaylistCreateResponse.fromMap(
        await requestGet('playlist/create', query: {
      'name': name,
      'privacy': privacy ? 10 : 0,
      'type': type,
    }));
  }

  static Future<BaseResponse> orderUpdate(List<int> ids) async {
    return BaseResponse.fromMap(
        await requestGet('playlist/order/update', query: {
      'ids': '[${ids.join(',')}]',
      't': DateTime.now().millisecondsSinceEpoch,
    }));
  }

  static Future<BaseResponse> delete(List<int> ids) async {
    return BaseResponse.fromMap(await requestGet("playlist/delete", query: {
      "id": ids.join(","),
    }));
  }

  static Future<BaseResponse> subscribe(int id, bool subscribe) async {
    return BaseResponse.fromMap(await requestGet("playlist/subscribe", query: {
      "id": id,
      "t": subscribe ? 1 : 2,
    }));
  }
}
