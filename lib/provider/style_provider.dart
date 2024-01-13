import 'package:qianshi_music/models/responses/style/style_album_response.dart';
import 'package:qianshi_music/models/responses/style/style_artist_response.dart';
import 'package:qianshi_music/models/responses/style/style_list_response.dart';
import 'package:qianshi_music/models/responses/style/style_playlist_response.dart';
import 'package:qianshi_music/models/responses/style/style_preference_response.dart';
import 'package:qianshi_music/models/responses/style/style_song_response.dart';
import 'package:qianshi_music/provider/index.dart';

class StyleProvider {
  static Future<StyleListResponse> list() async {
    return StyleListResponse.fromMap(await requestGet('style/list'));
  }

  static Future<StylePreferenceResponse> preference() async {
    return StylePreferenceResponse.fromMap(
        await requestGet('style/preference'));
  }

  static Future<StyleSongResponse> song(int tagId,
      {int size = 20, int cursor = 0, int sort = 0}) async {
    return StyleSongResponse.fromMap(await requestGet('style/song', query: {
      'tagId': tagId,
      'size': size,
      'cursor': cursor,
      'sort': sort,
    }));
  }

  static Future<StyleAlbumResponse> album(int tagId,
      {int size = 20, int cursor = 0, int sort = 0}) async {
    return StyleAlbumResponse.fromMap(await requestGet('style/album', query: {
      'tagId': tagId,
      'size': size,
      'cursor': cursor,
      'sort': sort,
    }));
  }

  static Future<StylePlaylistResponse> playlist(int tagId,
      {int size = 20, int cursor = 0, int sort = 0}) async {
    return StylePlaylistResponse.fromMap(
        await requestGet('style/playlist', query: {
      'tagId': tagId,
      'size': size,
      'cursor': cursor,
      'sort': sort,
    }));
  }

  static Future<StyleArtistResponse> artist(int tagId,
      {int size = 20, int cursor = 0, int sort = 0}) async {
    return StyleArtistResponse.fromMap(await requestGet('style/artist', query: {
      'tagId': tagId,
      'size': size,
      'cursor': cursor,
      'sort': sort,
    }));
  }
}

enum StyleType {
  song,
  album,
  plalist,
  artist,
}
