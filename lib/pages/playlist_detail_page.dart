import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/utils/http/http_util.dart';
import 'package:qianshi_music/utils/logger.dart';

class PlaylistDetailPage extends StatefulWidget {
  const PlaylistDetailPage({super.key});

  @override
  State<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  final int playlistId = Get.arguments;

  Future<void> getPlaylistDetail() async {
    final response = await HttpUtils.get('playlist/detail?id=$playlistId');
    logger.i(response.data);
  }

  @override
  void initState() {
    super.initState();
    getPlaylistDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PlaylistDetailPage"),
      ),
      body: const Center(
        child: Text("PlaylistDetailPage"),
      ),
    );
  }
}
