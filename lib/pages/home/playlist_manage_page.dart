import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/provider/playlist_provider.dart';
import 'package:qianshi_music/stores/current_user_controller.dart';

class PlaylistManagePage extends StatefulWidget {
  final List<Playlist> playlists;
  const PlaylistManagePage({
    super.key,
    required this.playlists,
  });

  @override
  State<PlaylistManagePage> createState() => _PlaylistManagePageState();
}

class CheckablePlaylist {
  final RxBool isCheck;
  final Playlist playlist;
  CheckablePlaylist(this.isCheck, this.playlist);
}

class _PlaylistManagePageState extends State<PlaylistManagePage> {
  final CurrentUserController currentUserController =
      Get.find<CurrentUserController>();
  List<CheckablePlaylist> list = [];

  bool isUpdateOrder = false;

  @override
  void initState() {
    super.initState();
    list =
        widget.playlists.map((e) => CheckablePlaylist(false.obs, e)).toList();
  }

  Future deletePlaylist() async {
    if (list.where((e) => e.isCheck.value).isEmpty) {
      Get.snackbar('删除失败', '未选择歌单');
      return;
    }
    try {
      await EasyLoading.show(status: '删除中');
      final response = await PlaylistProvider.delete(list
          .where((e) => e.isCheck.value)
          .map((e) => e.playlist.id)
          .toList());
      if (response.code != 200) {
        Get.snackbar('删除失败', response.msg ?? '未知错误');
        return;
      }
      list.removeWhere((e) => e.isCheck.value);
      setState(() {});
      Get.snackbar('删除成功', '');
      isUpdateOrder = true;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isUpdateOrder) {
          currentUserController.refreshMyPlaylist();
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
            title: Obx(() =>
                Text("当前已选择${list.where((e) => e.isCheck.value).length}个"))),
        body: Column(
          children: [
            Expanded(
              child: ReorderableListView.builder(
                buildDefaultDragHandles: true,
                itemBuilder: (context, index) {
                  var group = list[index];
                  return ListTile(
                    key: ValueKey(group.playlist.id),
                    onTap: () {
                      group.isCheck.value = !group.isCheck.value;
                    },
                    title: Text(group.playlist.name),
                    leading: IgnorePointer(
                      child: Obx(() => Checkbox(
                          value: group.isCheck.value, onChanged: (v) {})),
                    ),
                    trailing: ReorderableDragStartListener(
                      index: index,
                      child: const Icon(Icons.menu),
                    ),
                  );
                },
                itemCount: list.length,
                onReorder: (oldIndex, newIndex) async {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  list.insert(newIndex, list.removeAt(oldIndex));
                  try {
                    await EasyLoading.show(status: '更新中');
                    await PlaylistProvider.orderUpdate(
                        list.map((e) => e.playlist.id).toList());
                    isUpdateOrder = true;
                  } catch (e) {
                    Get.snackbar('更新失败', e.toString());
                  } finally {
                    await EasyLoading.dismiss();
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('取消'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      deletePlaylist();
                    },
                    child: const Text('删除'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
