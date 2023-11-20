import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/locale/locale_message.dart';
import 'package:qianshi_music/pages/login_page.dart';
import 'package:qianshi_music/pages/playlist_detail_page.dart';
import 'package:qianshi_music/pages/search_page.dart';
import 'package:qianshi_music/pages/settings_page.dart';
import 'package:qianshi_music/pages/splash_screen_page.dart';
import 'package:qianshi_music/provider/auth_provider.dart';
import 'package:qianshi_music/stores/index_controller.dart';
import 'package:qianshi_music/utils/http/http_util.dart';
import 'package:qianshi_music/utils/sputils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

late CookieJar jar;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initStore();
  runApp(const MyApp());
}

Future<void> initStore() async {
  await SpUtil().init();

  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final String appDocPath = appDocDir.path;
  jar = PersistCookieJar(
    ignoreExpires: true,
    storage: FileStorage("$appDocPath/.cookies/"),
  );

  HttpUtils.init(
      baseUrl: ApiContants.baseUrl, interceptors: [CookieManager(jar)]);
  Get.put(IndexController());
  Get.lazyPut(() => AuthProvider());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'QianShi Music',
      darkTheme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      builder: EasyLoading.init(),
      translations: LocaleMessage(),
      locale: Get.find<IndexController>().currentLocale.value,
      fallbackLocale: const Locale('en', 'US'),
      routes: {
        RouterContants.settings: (context) => const SettingsPage(),
        RouterContants.search: (context) => const SearchPage(),
        RouterContants.login: (context) => const LoginPage(),
        RouterContants.playlistDetail: (context) => const PlaylistDetailPage(),
      },
      home: const SplahScreenPage(),
    );
  }
}
