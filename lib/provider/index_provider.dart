import 'package:qianshi_music/models/responses/personal_fm_response.dart';
import 'package:qianshi_music/models/responses/recommend/personalized_response.dart';
import 'package:qianshi_music/provider/index.dart';

class IndexProvider {
  static Future<PersonalFmResponse> personalFm() async {
    return PersonalFmResponse.fromMap(await requestGet('personal_fm', query: {
      't': DateTime.timestamp().microsecond,
    }));
  }

  static Future<PersonalizedResponse> personalized({int limit = 30}) async {
    return PersonalizedResponse.fromMap(
        await requestGet('personalized', query: {
      'limit': limit,
      't': DateTime.now().microsecondsSinceEpoch,
    }));
  }
}
