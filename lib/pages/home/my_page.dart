import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/pages/base_playing_state.dart';
import 'package:qianshi_music/stores/current_user_controller.dart';
import 'package:qianshi_music/stores/playing_controller.dart';
import 'package:qianshi_music/widgets/fix_image.dart';
import 'package:qianshi_music/widgets/tiles/playlist_tile.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  BasePlayingState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends BasePlayingState<MyPage> {
  final CurrentUserController _currentUserController = Get.find();
  final PlayingController _playingController = Get.find();

  @override
  BorderRadius get borderRadius => const BorderRadius.only(
      topLeft: Radius.circular(16), topRight: Radius.circular(16));

  @override
  String get heroTag => "my_page_playing_bar";

  @override
  Widget buildPageBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildBaseInfo(),
          const SizedBox(height: 16),
          _buildLikePlaylist(context),
          const SizedBox(height: 16),
          _buildCreatePlaylist(),
        ],
      ),
    );
  }

  SizedBox _buildBaseInfo() {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: FixImage(
              imageUrl: _currentUserController.currentProfile.value == null
                  ? AssetsContants.defaultAvatar
                  : _currentUserController.currentProfile.value!.backgroundUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 16,
            right: 16,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: const BoxDecoration(
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
          ),
        ],
      ),
    );
  }

  Widget _buildLikePlaylist(BuildContext context) {
    final likePlaylist = _currentUserController.userPlaylist.isEmpty
        ? null
        : _currentUserController.userPlaylist[0];
    if (likePlaylist == null) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Get.toNamed(RouterContants.playlistDetail, arguments: {
            'heroTag': heroTag,
            'playlistId': likePlaylist.id,
          });
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FixImage(
                imageUrl: likePlaylist.coverImgUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    likePlaylist.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${likePlaylist.trackCount} 首",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () {
                _playingController.addPlaylist(likePlaylist, playNow: true);
              },
              child: const Text("播放全部"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatePlaylist() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 16),
            child: Text(
              "创建的歌单",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _currentUserController.userPlaylist.length - 1,
              itemBuilder: (context, index) {
                return PlaylistTile(
                    playlist: _currentUserController.userPlaylist[index + 1],
                    onTap: () {
                      Get.toNamed(
                        RouterContants.playlistDetail,
                        arguments: {
                          'heroTag': heroTag,
                          'playlistId':
                              _currentUserController.userPlaylist[index + 1].id,
                        },
                      );
                    });
              }),
        ],
      ),
    );
  }
}
