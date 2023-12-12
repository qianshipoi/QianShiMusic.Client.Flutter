import 'package:qianshi_music/models/responses/search_collect_response.dart';
import 'package:qianshi_music/models/responses/search_suggest_response.dart';
import 'package:qianshi_music/utils/http/http_util.dart';

enum MusicSearchType {
  song(1),
  artist(100),
  album(10),
  playlist(1000),
  mv(1004),
  djRadios(1009),
  userProfile(1002),
  video(1014),
  collect(1018);

  const MusicSearchType(this.number);
  final int number;

  static MusicSearchType fromValue(int val) {
    return MusicSearchType.values
        .firstWhere((element) => element.number == val);
  }
}

class SearchProvider {
  static Future<dynamic> search(String query, MusicSearchType type,
      {int limit = 10, int offset = 0}) async {
    final response = await HttpUtils.get('/search', params: {
      'keywords': query,
      'type': type.number,
      'limit': limit,
      'offset': offset
    });
    final data = response.statusCode == 200
        ? response.data
        : {
            'code': -1,
            'msg': '网络异常',
          };

    switch (type) {
      case MusicSearchType.song:
        return SearchSongResponse.fromMap(data);
      case MusicSearchType.artist:
        return SearchArtistResponse.fromMap(data);
      case MusicSearchType.album:
        return SearchAlbumResponse.fromMap(data);
      case MusicSearchType.video:
        return SearchVideoResponse.fromMap(data);
      case MusicSearchType.playlist:
        return SearchPlaylistResponse.fromMap(data);
      case MusicSearchType.djRadios:
        return SearchDjRadiosResponse.fromMap(data);
      case MusicSearchType.userProfile:
        return SearchUserProfileResponse.fromMap(data);
      case MusicSearchType.collect:
        return SearchCollectResponse.fromMap(data);
      case MusicSearchType.mv:
        return SearchMvResponse.fromMap(data);
    }
  }

  static Future<SearchSuggestResponse> suggest(String keywords,
      {bool isMobile = false}) async {
    final params = {
      'keywords': keywords,
    };
    if (isMobile) {
      params['type'] = 'mobile';
    }
    final response = await HttpUtils.get('/search/suggest', params: params);
    return response.statusCode == 200
        ? SearchSuggestResponse.fromMap(response.data)
        : SearchSuggestResponse(code: -1, msg: '请求失败');
  }
}
