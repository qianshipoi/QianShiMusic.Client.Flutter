import 'package:qianshi_music/models/responses/simi/simi_mv_response.dart';
import 'package:qianshi_music/provider/index.dart';

class SimiProvider {
  static Future<SimiMvResponse> mv(int id) async {
    return SimiMvResponse.fromMap(await requestGet('/simi/mv', query: {
      'id': id,
    }));
  }

  static Future<SimiMvResponse> song(int id) async {
    return SimiMvResponse.fromMap(await requestGet('/simi/song', query: {
      'id': id,
    }));
  }
}
