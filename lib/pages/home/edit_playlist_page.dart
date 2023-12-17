import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/provider/playlist_provider.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class EditPlaylistPage extends StatefulWidget {
  final Playlist playlist;
  const EditPlaylistPage({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  @override
  State<EditPlaylistPage> createState() => _EditPlaylistPageState();
}

class _EditPlaylistPageState extends State<EditPlaylistPage> {
  TextEditingController? _textController;

  _updateName() async {
    _textController?.dispose();
    _textController = TextEditingController(text: widget.playlist.name.value);

    Get.bottomSheet(
      SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("更新歌单名称"),
            actions: [
              TextButton(
                  onPressed: () async {
                    final name = _textController!.text;
                    if (name.isEmpty) {
                      Get.snackbar("错误", "名称不能为空");
                      return;
                    }

                    try {
                      await EasyLoading.show(status: "保存中");
                      final response = await PlaylistProvider.update(
                          widget.playlist.id,
                          name: name);
                      if (response.code != 200) {
                        Get.snackbar("更新歌单名称失败", response.msg!);
                        return;
                      }
                      widget.playlist.name.value = name;
                      Get.back();
                    } finally {
                      await EasyLoading.dismiss();
                    }
                  },
                  child: const Text("保存"))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
            child: TextField(
              controller: _textController,
              autofocus: true,
            ),
          ),
        ),
      ),
      ignoreSafeArea: false,
      isScrollControlled: true,
    );
  }

  @override
  void dispose() {
    _textController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑歌单信息'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildItem(
              '更换封面',
              Obx(() => FixImage(
                    imageUrl: formatMusicImageUrl(
                        widget.playlist.coverImgUrl.value,
                        size: 48),
                    width: 48,
                    height: 48,
                  )),
            ),
            _buildItem(
              '名称',
              Obx(() => Text(widget.playlist.name.value)),
              onTap: _updateName,
            ),
            _buildItem(
              '标签',
              Obx(() => Row(
                    children: widget.playlist.tags
                        .map(
                          (e) => Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 4),
                            child: Text(e),
                          ),
                        )
                        .toList(),
                  )),
            ),
            _buildItem(
              '描述',
              Obx(() => Text(widget.playlist.description.value ?? '')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String label, Widget child, {GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        constraints: const BoxConstraints(
          minHeight: 48,
        ),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            child,
          ],
        ),
      ),
    );
  }
}
