import 'package:qianshi_music/models/responses/comment/comment_floor_response.dart';
import 'package:qianshi_music/models/responses/comment/comment_mv_response.dart';
import 'package:qianshi_music/models/responses/comment/comment_new_response.dart';
import 'package:qianshi_music/utils/http/http_util.dart';

class CommentProvider {
  static Future<CommentNewResponse> new_(int id, int type,
      {int sortType = 1,
      int pageNo = 1,
      int pageSize = 20,
      int? cursor}) async {
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
    if (response.statusCode == 200) {
      return CommentNewResponse.fromMap(response.data);
    } else {
      return CommentNewResponse(code: -1, msg: "获取评论失败");
    }
  }

  static Future<CommentFloorResponse> floor(
    int id,
    int type,
    int parentCommentId, {
    int limit = 20,
    int? time,
  }) async {
    final queryParams = {
      "id": id.toString(),
      "parentCommentId": parentCommentId.toString(),
      "limit": limit.toString(),
      "type": type.toString(),
    };
    if (time != null) {
      queryParams['time'] = time.toString();
    }

    final response = await HttpUtils.get('comment/floor', params: queryParams);
    if (response.statusCode == 200) {
      return CommentFloorResponse.fromMap(response.data);
    } else {
      return CommentFloorResponse(code: -1, msg: "获取评论失败");
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
      return CommentMvResponse(code: -1, msg: "获取评论失败");
    }
  }
}
