import 'dart:io';

import 'package:dio/dio.dart';
import 'package:qianshi_music/utils/http/http.dart';
import 'package:qianshi_music/utils/http/net_cache_interceptor.dart';

class HttpUtils {
  static void init({
    required String baseUrl,
    int connectTimeout = 1500,
    int receiveTimeout = 1500,
    List<Interceptor>? interceptors,
  }) {
    Http().init(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        interceptors: interceptors,
        headers: {
          'Client-Type': 'flutter_${Platform.operatingSystem}',
        });
  }

  static void cancelRequests({required CancelToken token}) {
    Http().cancelRequests(token: token);
  }

  static Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    bool refresh = false,
    bool noCache = !CACHE_ENABLE,
    String? cacheKey,
    bool cacheDisk = false,
  }) async {
    return await Http().get(
      path,
      params: params,
      options: options,
      cancelToken: cancelToken,
      refresh: refresh,
      noCache: noCache,
      cacheKey: cacheKey,
    );
  }

  static Future<Response<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await Http().post<T>(
      path,
      data: data,
      params: params,
      options: options,
      cancelToken: cancelToken,
    );
  }

  static Future put(
    String path, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await Http().put(
      path,
      data: data,
      params: params,
      options: options,
      cancelToken: cancelToken,
    );
  }

  static Future patch(
    String path, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await Http().patch(
      path,
      data: data,
      params: params,
      options: options,
      cancelToken: cancelToken,
    );
  }

  static Future delete(
    String path, {
    data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await Http().delete(
      path,
      data: data,
      params: params,
      options: options,
      cancelToken: cancelToken,
    );
  }
}
