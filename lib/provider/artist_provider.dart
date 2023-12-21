import 'package:qianshi_music/models/responses/artist_desc_response.dart';
import 'package:qianshi_music/models/responses/artist_detail_response.dart';
import 'package:qianshi_music/models/responses/artist_sublist_response.dart';
import 'package:qianshi_music/models/responses/artist_top_songs_response.dart';
import 'package:qianshi_music/models/responses/base_response.dart';
import 'package:qianshi_music/provider/artist_album_response.dart';
import 'package:qianshi_music/provider/artist_mv_response.dart';
import 'package:qianshi_music/provider/artists_response.dart';
import 'package:qianshi_music/provider/index.dart';

class ArtistProvider {
  static Future<ArtistSublistResponse> sublist(
      {int limit = 25, int offset = 0}) async {
    return ArtistSublistResponse.fromMap(
        await requestGet('artist/sublist', query: {
      'limit': limit,
      'offset': offset,
    }));
  }

  static Future<BaseResponse> sub(int id, {bool isSub = true}) async {
    return BaseResponse.fromMap(await requestGet('artist/sub', query: {
      'id': id,
      't': isSub ? '1' : '0',
    }));
  }

  static Future<ArtistTopSongsResponse> topSongs(int id) async {
    return ArtistTopSongsResponse.fromMap(await requestGet('artist/top/songs'));
  }

  static Future<ArtistTopSongsResponse> songs(int id,
      {int limit = 50, int offset = 0, bool hotOrder = true}) async {
    return ArtistTopSongsResponse.fromMap(await requestGet(
      'artist/songs',
      query: {
        'id': id,
        'limit': limit,
        'offset': offset,
        'order': hotOrder ? 'hot' : 'time',
      },
    ));
  }

  static Future<ArtistDetailResponse> detail(int id) async {
    return ArtistDetailResponse.fromMap(await requestGet(
      'artist/detail',
      query: {
        'id': id,
      },
    ));
  }

  static Future<ArtistDescResponse> desc(int id) async {
    return ArtistDescResponse.fromMap(await requestGet(
      'artist/desc',
      query: {
        'id': id,
      },
    ));
  }

  static Future<ArtistsResponse> s(int id) async {
    return ArtistsResponse.fromMap(await requestGet(
      'artists',
      query: {
        'id': id,
      },
    ));
  }

  static Future<ArtistMvResponse> mv(int id,
      {int limit = 20, int offset = 0}) async {
    return ArtistMvResponse.fromMap(await requestGet(
      'artist/mv',
      query: {
        'id': id,
        'limit': limit,
        'offset': offset,
      },
    ));
  }

  static Future<ArtistAlbumResponse> album(int id,
      {int limit = 20, int offset = 0}) async {
    return ArtistAlbumResponse.fromMap(await requestGet(
      'artist/album',
      query: {
        'id': id,
        'limit': limit,
        'offset': offset,
      },
    ));
  }
}
