import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/main.dart';
import 'package:qianshi_music/models/responses/base_response.dart';

class ToastUtil {
  static void notify(String msg) {
    EasyLoading.showToast(msg);
  }

  static void error(String msg) {
    EasyLoading.showError(msg);
  }

  static void getNotifyError(String content, {String title = '错误'}) {
    final context = MyApp.navigatorKey.currentContext!;

    Get.snackbar(title, content,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Theme.of(context).colorScheme.error,
        instantInit: false,
        borderRadius: 6,
        icon: const Icon(Icons.error, color: Colors.redAccent),
        colorText: Theme.of(context).colorScheme.onError);
  }

  static Future<bool> alert(String title, String content,
      {bool showCancel = true}) async {
    return (await Get.dialog<bool>(AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            if (showCancel)
              TextButton(
                onPressed: () {
                  Get.back(result: false);
                },
                child: const Text("取消"),
              ),
            TextButton(
              onPressed: () async {
                Get.back(result: true);
              },
              child: const Text("确定"),
            ),
          ],
        ))) ??
        false;
  }

  static bool handleResponse(BaseResponse baseResponse, {String msg = '未知错误'}) {
    if (baseResponse.code == 200) {
      return true;
    } else {
      error(baseResponse.msg ?? msg);
      return false;
    }
  }
}
