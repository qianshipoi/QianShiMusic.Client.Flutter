import 'package:dio/dio.dart';
import 'package:qianshi_music/models/responses/comment/comment_mv_response.dart';
import 'package:qianshi_music/models/responses/comment/comment_new_mv_response.dart';
import 'package:qianshi_music/utils/http/http_util.dart';

import '../models/responses/comment/comment_new_response.dart';

class CommentProvider {
  static Future<T> new_<T extends CommentNewResponse>(int id,
      {int sortType = 1,
      int pageNo = 1,
      int pageSize = 20,
      int? cursor}) async {
    int type = -1;

    switch (T) {
      case CommentNewMvResponse:
        type = 1;
        break;
      default:
        throw Exception("未知类型");
    }

    final queryParams = {
      "id": id.toString(),
      "type": type.toString(),
      "sortType": sortType.toString(),
      "pageNo": pageNo.toString(),
      "pageSize": pageSize.toString(),
    };
    if (sortType == 3 && pageNo != 1 && cursor != null) {
      queryParams['cursor'] = cursor.toString();
    }

    final response = await HttpUtils.get('comment/new', params: queryParams);
    return _mapResponse<T>(response);
  }

  static T _mapResponse<T>(Response<dynamic> response) {
    switch (T) {
      case CommentNewMvResponse:
        if (response.statusCode == 200) {
          return CommentNewMvResponse.fromMap(response.data) as T;
        } else {
          return CommentNewMvResponse(data: null, code: -1, msg: "获取评论失败") as T;
        }
      default:
        throw Exception("未知类型");
    }
  }

  static Future<CommentMvResponse> mv(int id,
      {int limit = 20, int offset = 0, int? before}) async {
    final queryParams = {
      "id": id.toString(),
      "limit": limit.toString(),
      "offset": offset.toString(),
    };
    if (before != null) {
      queryParams['before'] = before.toString();
    }

    final response = await HttpUtils.get('comment/mv', params: queryParams);
    if (response.statusCode == 200) {
      return CommentMvResponse.fromMap(response.data);
    } else {
      return CommentMvResponse(
          topComments: [],
          hotComments: [],
          comments: [],
          more: false,
          total: 0,
          code: -1,
          msg: "获取评论失败");
    }
  }
}
