import 'package:dio/dio.dart';
import 'package:qianshi_music/constants.dart';

class RequestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters['realIP'] = "171.43.246.64";
    if (Global.cookie.isNotEmpty) {
      if (options.queryParameters['noCookie'] == null) {
        options.queryParameters['cookie'] = Uri.encodeComponent(Global.cookie);
      }
    }
    return super.onRequest(options, handler);
  }
}
