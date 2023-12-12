import 'package:dio/dio.dart';
import 'package:qianshi_music/utils/http/http_util.dart';

Future<Map<String, dynamic>> requestGet(String uri,
    {Map<String, dynamic>? query}) async {
  final response = await HttpUtils.get(uri, params: query);
  return formatResponse(response);
}

Map<String, dynamic> formatResponse(Response<dynamic> response) {
  if (response.statusCode != 200) {
    return {'code': -1, 'msg': '请求异常'};
  } else {
    return response.data;
  }
}
