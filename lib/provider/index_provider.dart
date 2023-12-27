import 'package:qianshi_music/models/responses/personal_fm_response.dart';
import 'package:qianshi_music/provider/index.dart';

class IndexProvider {
  static Future<PersonalFmResponse> personalFm() async {
    return PersonalFmResponse.fromMap(await requestGet('personal_fm', query: {
      't': DateTime.timestamp().microsecond,
    }));
  }
}
