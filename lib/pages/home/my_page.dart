import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/pages/base_playing_state.dart';
import 'package:qianshi_music/pages/home/playlist_manage_page.dart';
import 'package:qianshi_music/pages/playlist_detail_page.dart';
import 'package:qianshi_music/provider/playlist_provider.dart';
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

  Future<bool> _createNewPlaylist(String name) async {
    await EasyLoading.show(status: "创建中");
    try {
      final response = await PlaylistProvider.create(name);
      if (response.code != 200) {
        Get.snackbar("创建失败", response.msg!);
        return false;
      }
      Get.snackbar("创建成功", "歌单名称：$name");
      _currentUserController.createdPlaylist.insert(0, response.playlist!);
      return true;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  final _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _createNewPlaylistDialog() async {
    _textEditingController.clear();
    final result = await Get.dialog<String>(AlertDialog(
      title: const Text("创建歌单"),
      content: TextField(
        controller: _textEditingController,
        decoration: const InputDecoration(
          hintText: "请输入歌单名称",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(result: null);
          },
          child: const Text("取消"),
        ),
        TextButton(
          onPressed: () async {
            if (_textEditingController.value.text.isEmpty) {
              Get.snackbar("创建失败", "歌单名称不能为空");
              return;
            }

            final result =
                await _createNewPlaylist(_textEditingController.value.text);
            if (result) {
              Get.back(result: null);
            }
            Get.back(result: "歌单名称");
          },
          child: const Text("确定"),
        ),
      ],
    ));
    if (result != null) {
      Get.snackbar("创建成功", "歌单名称：$result");
    }
  }

  _playlistManage() {
    Get.bottomSheet(
      backgroundColor: Theme.of(context).colorScheme.background,
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "歌单管理",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text("创建新歌单"),
              onTap: () {
                Get.back();
                _createNewPlaylistDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text("歌单管理"),
              onTap: () {
                Get.back();
                Get.to(() => PlaylistManagePage(
                      playlists:
                          _currentUserController.createdPlaylist.toList(),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }

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
    final likePlaylist = _currentUserController.likedPlaylist.value;
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
          Get.to(() => PlaylistDetailPage(
                playlistId: likePlaylist.id,
                heroTag: heroTag,
              ));
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "创建的歌单",
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                IconButton(
                    onPressed: _playlistManage,
                    icon: const Icon(Icons.more_vert))
              ],
            ),
          ),
          Obx(() {
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _currentUserController.createdPlaylist.length,
              itemBuilder: (context, index) {
                return PlaylistTile(
                    playlist: _currentUserController.createdPlaylist[index],
                    onTap: () {
                      Get.to(() => PlaylistDetailPage(
                            playlistId: _currentUserController
                                .createdPlaylist[index].id,
                            heroTag: heroTag,
                          ));
                    });
              },
            );
          }),
        ],
      ),
    );
  }
}
