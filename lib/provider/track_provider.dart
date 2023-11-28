import 'package:qianshi_music/models/responses/lyric_response.dart';
import 'package:qianshi_music/models/responses/song_url_response.dart';
import 'package:qianshi_music/utils/http/http_util.dart';

enum MusicLevel {
  standard,
  higher,
  exhigh,
  loosless,
  hires,
  jyeffect,
  sky,
  jymaster
}

class SongProvider {
  static Future<SongUrlResponse> url(String idOrIds) async {
    final response = await HttpUtils.get<dynamic>('/song/url', params: {
      'id': idOrIds,
    });
    return response.statusCode == 200
        ? SongUrlResponse.fromMap(response.data)
        : SongUrlResponse(code: -1, msg: '请求失败');
  }

  static Future<SongUrlResponse> urlV1(String idOrIds, MusicLevel level) async {
    final response = await HttpUtils.get<dynamic>('/song/url/v1', params: {
      'id': idOrIds,
      'level': level.toString(),
    });
    return response.statusCode == 200
        ? SongUrlResponse.fromMap(response.data)
        : SongUrlResponse(code: -1, msg: '请求失败');
  }

  static Future<LyricResponse> lyric(int id) async {
    final response = await HttpUtils.get<dynamic>('/lyric', params: {
      'id': id,
    });
    return response.statusCode == 200
        ? LyricResponse.fromMap(response.data)
        : LyricResponse(code: -1, msg: '请求失败');
  }

  static Future<SongDetailResponse> detail(String id) async {
    final response = await HttpUtils.get<dynamic>('/song/detail', params: {
      'ids': id,
    });
    return response.statusCode == 200
        ? SongDetailResponse.fromMap(response.data)
        : SongDetailResponse(code: -1, msg: '请求失败');
  }
}
