import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/pages/home_page.dart';
import 'package:lottie/lottie.dart';
import 'package:qianshi_music/pages/login_page.dart';
import 'package:qianshi_music/provider/auth_provider.dart';
import 'package:qianshi_music/stores/current_user_controller.dart';
import 'package:qianshi_music/utils/sputils.dart';

class SplahScreenPage extends StatefulWidget {
  const SplahScreenPage({super.key});

  @override
  State<SplahScreenPage> createState() => _SplahScreenPageState();
}

class _SplahScreenPageState extends State<SplahScreenPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(750, 1334));
    return Scaffold(
      body: Lottie.asset(AssetsContants.chatLottie,
          repeat: false,
          controller: _controller,
          animate: true,
          height: MediaQuery.of(context).size.height, onLoaded: (composition) {
        _controller
          ..duration = composition.duration
          ..forward().whenComplete(() => _checkToken(context));
      }),
    );
  }

  Future _checkToken(context) async {
    final isLogin = SpUtil().getBool("IsLogin") ?? false;
    if (!isLogin) {
      Get.off(() => const LoginPage());
      return;
    }
    Global.cookie = SpUtil().getString("cookie") ?? "";
    final response = await AuthProvider.account();
    if (response.code == 200) {
      final currentUserController = Get.find<CurrentUserController>();
      currentUserController.currentAccount.value = response.account;
      currentUserController.currentProfile.value = response.profile;
      Get.off(() => const HomePage());
    } else {
      Get.off(() => const LoginPage());
    }
  }
}
