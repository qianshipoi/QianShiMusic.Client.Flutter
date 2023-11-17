import 'dart:typed_data';

import 'package:dio/dio.dart';

const String bytesUserAgent =
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36 Edg/118.0.2088.76";

class SSJRequestManager {
  final Dio _dio = Dio();

  Dio getDio() {
    return _dio;
  }

  SSJRequestManager();

  Future<Uint8List> getBytes(String path, Map<String, dynamic> params) async {
    var options = Options(
        method: "GET",
        responseType: ResponseType.bytes,
        headers: {"User-Agent": bytesUserAgent});

    return await _dio
        .get(path, queryParameters: params, options: options)
        .then((value) => value.data);
  }
}

final SSJRequestManager ssjRequestManager = SSJRequestManager();
