import 'package:dio/dio.dart';
import 'package:qianshi_music/constants.dart';

class RequestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (Global.cookie.isNotEmpty) {
      if (options.queryParameters['noCookie'] == null) {
        options.queryParameters['cookie'] = Uri.encodeComponent(Global.cookie);
      }
    }
    return super.onRequest(options, handler);
  }
}
