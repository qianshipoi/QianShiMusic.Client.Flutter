import 'package:qianshi_music/models/responses/record/record_recent_response.dart';
import 'package:qianshi_music/provider/index.dart';

class RecordProvider {
  static Future<RecordRecentResponse> recentSong({int limit = 100}) async {
    return RecordRecentResponse.fromMap(
        await requestGet('record/recent/song', query: {
      'limit': limit,
    }));
  }

  static Future<RecordRecentResponse> recentAlbum({int limit = 100}) async {
    return RecordRecentResponse.fromMap(
        await requestGet('record/recent/album', query: {
      'limit': limit,
    }));
  }

  static Future<RecordRecentResponse> recentVideo({int limit = 100}) async {
    return RecordRecentResponse.fromMap(
        await requestGet('record/recent/video', query: {
      'limit': limit,
    }));
  }

  static Future<RecordRecentResponse> recentPlaylist({int limit = 100}) async {
    return RecordRecentResponse.fromMap(
        await requestGet('record/recent/playlist', query: {
      'limit': limit,
    }));
  }
}
