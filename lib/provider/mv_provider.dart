import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/responses/mv/mv_detail_response.dart';
import 'package:qianshi_music/models/responses/mv/mv_sublist_response.dart';
import 'package:qianshi_music/provider/index.dart';

class MvProvider {
  static Future<MvSublistResponse> sublist(
      {int limit = 25, int offset = 0}) async {
    return MvSublistResponse.fromMap(await requestGet('mv/sublist', query: {
      'limit': limit,
      'offset': offset,
    }));
  }

  static Future<BaseResponse> sub(int id, {bool isSub = true}) async {
    return BaseResponse.fromMap(await requestGet('mv/sub', query: {
      'id': id,
      't': isSub ? '1' : '0',
    }));
  }

  static Future<MvDetailResponse> detail(int id) async {
    return MvDetailResponse.fromMap(await requestGet('mv/detail', query: {
      'mvid': id,
    }));
  }
}
