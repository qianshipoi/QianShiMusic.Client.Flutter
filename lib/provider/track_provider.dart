import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/models/responses/song/check_music_response.dart';
import 'package:qianshi_music/models/responses/song/likelist_response.dart';
import 'package:qianshi_music/models/responses/song/lyric_response.dart';
import 'package:qianshi_music/models/responses/song/song_detail_response.dart';
import 'package:qianshi_music/models/responses/song/song_url_response.dart';
import 'package:qianshi_music/models/responses/song/top_song_response.dart';
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

  static Future<CheckMusicResponse> checkMusic(int id,
      {int br = 999000}) async {
    return CheckMusicResponse.fromMap(
        await requestGet('check/music', query: {'id': id, 'br': br}));
  }

  static Future<TopSongResponse> topSong(TrackAddressType type) async {
    return TopSongResponse.fromMap(await requestGet('top/song', query: {
      'type': type.number,
    }));
  }
}

enum TrackAddressType {
  all(0),
  chinese(7),
  europe(96),
  japan(8),
  korea(16);

  const TrackAddressType(this.number);
  final int number;

  static TrackAddressType fromValue(int val) {
    return TrackAddressType.values
        .firstWhere((element) => element.number == val);
  }
}
