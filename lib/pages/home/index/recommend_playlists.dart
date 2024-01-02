import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/pages/playlist_page.dart';
import 'package:qianshi_music/provider/recommend_provider.dart';
import 'package:qianshi_music/widgets/card/playlist_card.dart';
import 'package:qianshi_music/widgets/horizontal_title_list_view.dart';

class RecommendPlaylists extends StatefulWidget {
  const RecommendPlaylists({super.key});

  @override
  State<RecommendPlaylists> createState() => _RecommendPlaylistsState();
}

class _RecommendPlaylistsState extends State<RecommendPlaylists> {
  final List<Playlist> playlists = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
  }

  Future<void> loadData() async {
    final response = await RecommendProvider.resource();
    if (response.code != 200) {
      Get.snackbar('获取每日推荐歌单失败', response.msg!);
      return;
    }
    playlists.addAll(response.recommend);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return HorizontalTitleListView(
      title: "每日推荐",
      onTap: () => Get.to(() => const PlaylistPage()),
      listView: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: PlaylistCard(playlist: playlist),
          );
        },
      ),
    );
  }
}
