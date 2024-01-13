import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/locale/locale_message.dart';
import 'package:qianshi_music/pages/login_page.dart';
import 'package:qianshi_music/pages/search_page.dart';
import 'package:qianshi_music/pages/search_result_page.dart';
import 'package:qianshi_music/pages/settings_page.dart';
import 'package:qianshi_music/pages/splash_screen_page.dart';
import 'package:qianshi_music/provider/auth_provider.dart';
import 'package:qianshi_music/stores/current_user_controller.dart';
import 'package:qianshi_music/stores/index_controller.dart';
import 'package:qianshi_music/stores/playing_controller.dart';
import 'package:qianshi_music/utils/http/http_util.dart';
import 'package:qianshi_music/utils/sputils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initStore();
  runApp(const MyApp());
}

Future<void> initStore() async {
  await SpUtil().init();
  HttpUtils.init(baseUrl: ApiContants.baseUrl);
  Get.put(IndexController());
  Get.put(CurrentUserController());
  Get.put(PlayingController());
  Get.lazyPut(() => AuthProvider());
  EasyLoading.instance.indicatorWidget = const SizedBox(
      height: 60,
      width: 60,
      child: Image(image: AssetImage(AssetsContants.loading)));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'QianShi Music',
      darkTheme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xFF45046A),
          secondary: Color(0xFF5C2A9D),
          surface: Color(0xFF4D4C7D),
          background: Color(0xFF202040),
          error: Color(0xFF7D0633),
          onPrimary: Color(0xFFBBE1FA),
          onSecondary: Color(0xFFBBE1FA),
          onSurface: Color(0xFFBBE1FA),
          onBackground: Color(0xFFBBE1FA),
          onError: Color(0xFFFFFFFF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xFFD9EDBF),
          secondary: Color(0xFFFDFFAB),
          surface: Color(0xFFDCF2F1),
          background: Color(0xFFEEF5FF),
          error: Color(0xFFFFB996),
          onPrimary: Color(0xFF45474B),
          onSecondary: Color(0xFF45474B),
          onSurface: Color(0xFF45474B),
          onBackground: Color(0xFF45474B),
          onError: Color(0xFFFFFFFF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      builder: EasyLoading.init(),
      translations: LocaleMessage(),
      locale: Get.find<IndexController>().currentLocale.value,
      fallbackLocale: const Locale('en', 'US'),
      routes: {
        RouterContants.settings: (context) => const SettingsPage(),
        RouterContants.search: (context) => const SearchPage(),
        RouterContants.login: (context) => const LoginPage(),
        RouterContants.searchResult: (context) =>
            SearchResultPage(keyword: Get.arguments),
      },
      home: const SplahScreenPage(),
    );
  }
}
