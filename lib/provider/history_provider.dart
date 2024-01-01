import 'package:qianshi_music/models/responses/history_recommendsongs_response.dart';
import 'package:qianshi_music/provider/index.dart';

class HistoryProvider {
  static Future<HistoryRecommendSongsResponse> recommendSongs() async {
    return HistoryRecommendSongsResponse.fromMap(
        await requestGet('history/recommend/songs'));
  }

  static Future<HistoryRecommendSongsResponse> recommendSongsDetail(
      String date) async {
    return HistoryRecommendSongsResponse.fromMap(
        await requestGet('history/recommend/songs/detail', query: {
      'date': date,
    }));
  }
}
