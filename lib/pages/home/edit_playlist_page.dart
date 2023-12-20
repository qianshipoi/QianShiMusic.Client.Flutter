import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/pages/home/selection_tags_page.dart';
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
  final RxList<String> _tags = <String>[].obs;
  final List<String> _allTags = [];
  final ImagePicker _imagePicker = ImagePicker();

  _getAllTags() async {
    final response = await PlaylistProvider.catlist();
    if (response.code != 200) {
      Get.snackbar("获取标签失败", response.msg!);
      return;
    }
    _allTags.addAll(response.sub.map((e) => e.name));
  }

  _updateTags() async {
    _tags.clear();
    _tags.addAll(widget.playlist.tags.toList());
    if (_allTags.isEmpty) {
      await _getAllTags();
    }

    Get.to(() => SelectionTagsPage(
          tags: _allTags,
          selectedTags: widget.playlist.tags.toList(),
        ))?.then((value) async {
      if (value == null) {
        return;
      }
      final response =
          await PlaylistProvider.tagsUpdate(widget.playlist.id, value);
      if (response.code != 200) {
        Get.snackbar("保存标签失败", response.msg!);
        return;
      }
      widget.playlist.tags.clear();
      widget.playlist.tags.addAll(value);
    });
  }

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
                      final response = await PlaylistProvider.nameUpdate(
                          widget.playlist.id, name);
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

  _updateDesc() async {
    _textController?.dispose();
    _textController =
        TextEditingController(text: widget.playlist.description.value);

    Get.bottomSheet(
      SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text("更新歌单描述"),
            actions: [
              TextButton(
                  onPressed: () async {
                    final desc = _textController?.text ?? '';
                    try {
                      await EasyLoading.show(status: "保存中");
                      final response = await PlaylistProvider.descUpdate(
                          widget.playlist.id, desc);
                      if (response.code != 200) {
                        Get.snackbar("更新歌单描述失败", response.msg!);
                        return;
                      }
                      widget.playlist.description.value = desc;
                      Get.back();
                    } finally {
                      await EasyLoading.dismiss();
                    }
                  },
                  child: const Text("保存"))
            ],
          ),
          body: Padding(
            padding:
                const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 16),
            child: TextField(
              controller: _textController,
              keyboardType: TextInputType.multiline,
              maxLength: 1000,
              maxLines: 50,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: '输入歌单描述',
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                isDense: true,
                border: OutlineInputBorder(
                  gapPadding: 0,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                    width: 1,
                    style: BorderStyle.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      ignoreSafeArea: false,
      isScrollControlled: true,
    );
  }

  _updateCover() async {
    final file = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (file == null) return;
    final filePath = await _cropImage(file.path);
    try {
      await EasyLoading.show(status: "上传中");
      final response = await PlaylistProvider.coverUpdate(
          widget.playlist.id, File(filePath));
      if (response.code != 200) {
        Get.snackbar("更新歌单封面失败", response.msg!);
        return;
      }
      widget.playlist.coverImgUrl.value = response.data!.url;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future<String> _cropImage(String imagePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      compressFormat: ImageCompressFormat.jpg,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    return croppedFile?.path ?? imagePath;
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
              onTap: _updateCover,
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
              onTap: _updateTags,
            ),
            _buildItem(
              '描述',
              Obx(() => Text(widget.playlist.description.value ?? '')),
              onTap: _updateDesc,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 48, child: Text(label)),
            child,
          ],
        ),
      ),
    );
  }
}
