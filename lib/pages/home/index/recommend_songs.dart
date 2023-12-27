import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/pages/home/index/recommend_playlists.dart';
import 'package:qianshi_music/provider/recommend_provider.dart';

class RecommendSongs extends StatefulWidget {
  const RecommendSongs({super.key});

  @override
  State<RecommendSongs> createState() => _RecommendSongsState();
}

class _RecommendSongsState extends State<RecommendSongs> {
  final List<List<Track>> songs = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
  }

  Future<void> loadData() async {
    final response = await RecommendProvider.songs();
    if (response.code != 200) {
      Get.snackbar('获取每日推荐歌曲失败', response.msg!);
      return;
    }
    songs.addAll(response.)
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
