import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/pages/home_page.dart';
import 'package:lottie/lottie.dart';
import 'package:qianshi_music/pages/login_page.dart';
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

  _checkToken(context) {
    if (SpUtil().getBool("IsLogin") ?? false) {
      Get.off(() => const HomePage());
    } else {
      Get.off(() => const LoginPage());
    }
  }
}
