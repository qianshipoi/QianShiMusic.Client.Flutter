import 'package:qianshi_music/models/responses/recommend_resource_response.dart';
import 'package:qianshi_music/models/responses/recommend_songs_dislike_response.dart';
import 'package:qianshi_music/models/responses/recommend_songs_response.dart';
import 'package:qianshi_music/provider/index.dart';

class RecommendProvider {
  // 每日推荐歌曲
  static Future<RecommendSongsResponse> songs() async {
    return RecommendSongsResponse.fromMap(await requestGet('recommend/songs'));
  }

  // 每日推荐歌单
  static Future<RecommendResourceResponse> resource() async {
    return RecommendResourceResponse.fromMap(
        await requestGet('recommend/resource'));
  }

  // 不喜欢推荐歌曲
  static Future<RecommendSongsDislikeResponse> songsDislike(int id) async {
    return RecommendSongsDislikeResponse.fromMap(
        await requestGet('recommend/songs/dislike', query: {'id': id}));
  }
}
