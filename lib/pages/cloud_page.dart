import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qianshi_music/models/responses/cloud/user_cloud_response.dart';
import 'package:qianshi_music/pages/play_song/play_song_page.dart';
import 'package:qianshi_music/provider/track_provider.dart';
import 'package:qianshi_music/provider/user_provider.dart';
import 'package:qianshi_music/stores/playing_controller.dart';
import 'package:qianshi_music/widgets/tiles/private_cloud_tile.dart';

class CloudPage extends StatefulWidget {
  const CloudPage({super.key});

  @override
  State<CloudPage> createState() => _CloudPageState();
}

class _CloudPageState extends State<CloudPage> {
  final _refreshController = RefreshController(initialRefresh: false);
  final PlayingController _playingController = Get.find();

  final _list = <PrivateCloud>[];
  bool _more = true;
  int _offset = 0;
  final _limit = 20;

  @override
  void initState() {
    super.initState();
    _onLoading();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future _onLoading() async {
    if (!_more) {
      _refreshController.loadNoData();
      return;
    }
    final response = await UserProvider.cloud(offset: _offset, limit: _limit);
    if (response.code != 200) {
      Get.snackbar("获取歌曲失败", response.msg!);
      return;
    }
    _list.addAll(response.data);
    _offset = _list.length;
    _more = response.hasMore;
    _refreshController.loadComplete();
    setState(() {});
    if (!_more) {
      _refreshController.loadNoData();
    }
  }

  Future _upload() async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      dialogTitle: '选择音乐文件',
      allowedExtensions: ['mp3'],
    );
    if (result == null) return;
    final file = result.files.first;
    try {
      await EasyLoading.show(status: '上传中...');
      final response = await UserProvider.cloudAdd(File(file.path!));
      if (response.code != 200) {
        Get.snackbar('上传失败', response.msg!);
        return;
      }
      _list.insert(0, response.privateCloud!);
      setState(() {});
    } catch (e) {
      Get.snackbar('上传失败', e.toString());
      return;
    } finally {
      await EasyLoading.dismiss();
    }
  }

  Future _trackMore(PrivateCloud privateCloud) async {
    Get.bottomSheet(
      Container(
        color: Theme.of(context).cardColor,
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('删除'),
              onTap: () async {
                try {
                  await EasyLoading.show(status: '删除中...');
                  final response =
                      await UserProvider.cloudDel([privateCloud.songId]);
                  if (response.code != 200) {
                    Get.snackbar('删除失败', response.msg!);
                    return;
                  }
                  _list.remove(privateCloud);
                  setState(() {});
                  Get.back();
                } finally {
                  await EasyLoading.dismiss();
                }
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的音乐云盘'),
        actions: [
          IconButton(
            onPressed: _upload,
            icon: const Icon(Icons.upload_file),
          ),
        ],
      ),
      body: _buildTrackListView(),
    );
  }

  SmartRefresher _buildTrackListView() {
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      enablePullDown: false,
      onLoading: _onLoading,
      child: ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index) {
          final privateCloud = _list[index];
          return PrivateCloudTile(
            privateCloud: privateCloud,
            index: index,
            onTap: () async {
              final response = await SongProvider.detail(
                  _list.map((e) => e.songId).toList());
              if (response.code != 200) {
                Get.snackbar('获取歌曲详情失败', response.msg!);
                return;
              }
              _playingController.addTracks(response.songs, palyNowIndex: index);
              Get.to(() => PlaySongPage.instance);
            },
            onMoreTap: () async => await _trackMore(privateCloud),
          );
        },
      ),
    );
  }
}
