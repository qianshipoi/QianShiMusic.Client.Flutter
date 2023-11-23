import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/models/responses/login_anonimous_response.dart';
import 'package:qianshi_music/models/responses/login_callphone_response.dart';
import 'package:qianshi_music/models/responses/user_account_response.dart';
import 'package:qianshi_music/utils/http/app_exception.dart';

import 'package:qianshi_music/utils/http/http_util.dart';
import 'package:qianshi_music/utils/logger.dart';

import 'package:dio/dio.dart' as dio;

class AuthProvider {
  static Future<void> logout() async {
    await HttpUtils.get('logout');
  }

  Future<dynamic> getCaptcha(String phone) async {
    return HttpUtils.get<dynamic>('captcha/sent?phone=$phone');
  }

  static Future<dio.Response<dynamic>> sent(String phone) {
    return HttpUtils.get<dynamic>('captcha/sent?phone=$phone');
  }

  static Future<LoginCallphoneResponse> login(
    String account, {
    String? captcha,
    String? password,
  }) async {
    Map<String, Object> data = {
      'phone': account,
      't': DateTime.now().millisecondsSinceEpoch,
      'noCookie': true,
    };
    if (captcha != null) {
      data['captcha'] = captcha;
    }
    if (password != null) {
      data['md5_password'] = md5.convert(utf8.encode(password)).toString();
    }
    logger.i(data);
    final response =
        await HttpUtils.post<dynamic>('login/cellphone', data: data);
    logger.i(response.data);

    if (response.statusCode == 200) {
      return LoginCallphoneResponse.fromMap(response.data!);
    } else {
      Get.snackbar("登录失败", "账号或密码错误");
    }
    return LoginCallphoneResponse.fromMap(response.data!);
  }

  static Future<LoginAnonimousResponse> anonimous() async {
    final response = await HttpUtils.get<dynamic>('register/anonimous');
    return response.statusCode == 200
        ? LoginAnonimousResponse.fromMap(response.data!)
        : LoginAnonimousResponse(code: -1, cookie: null);
  }

  static Future<UserAccountResponse> account() async {
    try {
      final response = await HttpUtils.get('user/account', params: {
        't': DateTime.now().millisecondsSinceEpoch,
      });
      return UserAccountResponse.fromMap(response.data);
    } on DioException catch (e) {
      final error = e.error as AppException;
      Get.snackbar("错误", error.getMessage());
      return UserAccountResponse(code: -406, msg: error.getMessage());
    }
  }
}
