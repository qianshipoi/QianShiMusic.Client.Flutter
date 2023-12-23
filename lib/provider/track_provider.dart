import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/responses/likelist_response.dart';
import 'package:qianshi_music/models/responses/lyric_response.dart';
import 'package:qianshi_music/models/responses/song_detail_response.dart';
import 'package:qianshi_music/models/responses/song_url_response.dart';
import 'package:qianshi_music/provider/index.dart';

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
  static Future<SongUrlResponse> url(List<int> ids) async {
    return SongUrlResponse.fromMap(
        await requestGet('song/url', query: {'id': ids.join(',')}));
  }

  static Future<SongUrlResponse> urlV1(List<int> ids, MusicLevel level) async {
    return SongUrlResponse.fromMap(await requestGet('song/url/v1', query: {
      'id': ids.join(','),
      'level': level.toString(),
    }));
  }

  static Future<LyricResponse> lyric(int id) async {
    return LyricResponse.fromMap(await requestGet('lyric', query: {'id': id}));
  }

  static Future<SongDetailResponse> detail(List<int> ids) async {
    return SongDetailResponse.fromMap(
        await requestGet('song/detail', query: {'ids': ids.join(',')}));
  }

  static Future<BaseResponse> like(int id, {bool like = true}) async {
    return BaseResponse.fromMap(
        await requestGet('like', query: {'id': id, 'like': like}));
  }

  static Future<LikelistResponse> likelist() async {
    return LikelistResponse.fromMap(await requestGet('likelist'));
  }
}
