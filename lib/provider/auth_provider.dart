import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:get/get.dart';

class AuthProvider extends GetConnect {
  Future<Response> login(String account, String password) {
    return post('login/cellphone', {
      'account': account,
      'md5_password': md5.convert(utf8.encode(password)).toString(),
    });
  }

  Future<Response> anonimous() async {
    var response = await get('register/anonimous');

    return response;
  }
}
