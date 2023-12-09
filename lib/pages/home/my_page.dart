import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/stores/current_user_controller.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final CurrentUserController _currentUserController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 241, 240, 238),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildBaseInfo(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  SizedBox _buildBaseInfo() {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Positioned.fill(
            child: FixImage(
              imageUrl: _currentUserController.currentProfile.value == null
                  ? AssetsContants.defaultAvatar
                  : _currentUserController.currentProfile.value!.backgroundUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(32)),
              ),
              child: Stack(
                children: [
                  Transform.translate(
                    offset: const Offset(0, -32),
                    child: const Align(
                      alignment: Alignment.topCenter,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(32)),
                        child: FixImage(
                            imageUrl: AssetsContants.defaultAvatar,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 48),
                      Text(
                        _currentUserController.currentProfile.value == null
                            ? "未登录"
                            : _currentUserController
                                .currentProfile.value!.nickname,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${_currentUserController.currentProfile.value == null ? 0 : _currentUserController.currentProfile.value!.follows} 关注",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${_currentUserController.currentProfile.value == null ? 0 : _currentUserController.currentProfile.value!.followeds} 粉丝",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Lv.${_currentUserController.currentProfile.value == null ? 0 : _currentUserController.currentProfile.value!.vipType}",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
