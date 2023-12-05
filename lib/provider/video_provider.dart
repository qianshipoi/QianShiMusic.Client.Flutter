import 'package:qianshi_music/models/responses/mv_url_response.dart';
import 'package:qianshi_music/utils/http/http_util.dart';

class VideoProvider {
  static Future<MvUrlResponse> url(int mvId) async {
    final response = await HttpUtils.get<dynamic>('/mv/url', params: {
      'id': mvId,
    });
    return response.statusCode == 200
        ? MvUrlResponse.fromMap(response.data)
        : MvUrlResponse(code: -1, msg: '请求失败');
  }
}
