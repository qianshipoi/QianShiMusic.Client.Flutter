import 'package:qianshi_music/models/responses/toplist/toplist_detail_response.dart';
import 'package:qianshi_music/provider/index.dart';

class ToplistProvider{
  static Future<ToplistDetailResponse> detail () async{
    return ToplistDetailResponse.fromMap(await requestGet('toplist/detail'));
  }
}
