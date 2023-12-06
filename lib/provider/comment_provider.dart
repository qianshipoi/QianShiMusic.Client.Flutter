import 'package:qianshi_music/models/responses/comment/comment_mv_response.dart';
import 'package:qianshi_music/utils/http/http_util.dart';

class CommentProvider {
  static Future<CommentMvResponse> mv(int id,
      {int limit = 20, int offset = 0, int? before}) async {
    final queryParams = {
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
