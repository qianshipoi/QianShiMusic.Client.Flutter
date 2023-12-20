import 'dart:io';

import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/responses/playlist_catlist_response.dart';
import 'package:qianshi_music/models/responses/playlist_cover_update_response.dart';
import 'package:qianshi_music/models/responses/playlist_create_resppnse.dart';
import 'package:qianshi_music/models/responses/playlist_detail_response.dart';
import 'package:qianshi_music/models/responses/playlist_top_response.dart';
import 'package:qianshi_music/models/responses/playlist_track_all_response.dart';
import 'package:qianshi_music/provider/index.dart';
import 'package:qianshi_music/utils/http/http_util.dart';

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

  static Future<BaseResponse> update(int id, String name,
      {String? desc, List<String>? tags}) async {
    final Map<String, dynamic> query = {
      'id': id,
      'name': name,
    }
      ..addIf(desc != null, 'desc', desc)
      ..addIf(tags != null, 'tags', tags?.join(';'));
    return BaseResponse.fromMap(
        await requestGet('playlist/update', query: query));
  }

  static Future<BaseResponse> nameUpdate(int id, String name) async {
    return BaseResponse.fromMap(
        await requestGet('playlist/name/update', query: {
      'id': id,
      'name': name,
    }));
  }

  static Future<BaseResponse> descUpdate(int id, String? desc) async {
    return BaseResponse.fromMap(await requestGet('playlist/name/update',
        query: {
          'id': id,
        }..addIf(desc != null, 'desc', desc)));
  }

  static Future<BaseResponse> tagsUpdate(int id, List<String> tags) async {
    return BaseResponse.fromMap(
        await requestGet('playlist/tags/update', query: {
      'id': id,
      'tags': tags.join(';'),
    }));
  }

  static Future<PlaylistCoverUpdateResponse> coverUpdate(int id, File imageFile,
      {int imageSize = 300}) async {
    final response = await HttpUtils.post("playlist/cover/update",
        data: dio.FormData.fromMap({
          'imgFile': dio.MultipartFile.fromString(imageFile.path),
          'imgSize': imageSize,
        }),
        params: {
          'id': id,
        });

    return PlaylistCoverUpdateResponse.fromMap(formatResponse(response));
  }
}
