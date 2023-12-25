import 'package:qianshi_music/models/responses/album_sublist_response.dart';
import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/provider/index.dart';

import '../models/responses/album_response.dart';

class AlbumProvider {
  static Future<AlbumSublistResponse> sublist(
      {int limit = 25, int offset = 0}) async {
    return AlbumSublistResponse.fromMap(
        await requestGet('album/sublist', query: {
      'limit': limit,
      'offset': offset,
    }));
  }

  static Future<BaseResponse> sub(int id, {bool isSub = true}) async {
    return BaseResponse.fromMap(await requestGet('album/sub', query: {
      'id': id,
      't': isSub ? '1' : '0',
    }));
  }

  static Future<AlbumResponse> index(int id) async{
    return AlbumResponse.fromMap(await requestGet('album', query: {
      'id': id,
    }));
  }
}
