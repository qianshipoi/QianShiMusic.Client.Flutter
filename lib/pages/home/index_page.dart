import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/pages/base_playing_state.dart';
import 'package:qianshi_music/pages/playlist_detail_page.dart';
import 'package:qianshi_music/provider/recommend_provider.dart';
import 'package:qianshi_music/widgets/tiles/playlist_tile.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends BasePlayingState<IndexPage> {
  List<Playlist> _playlists = [];

  Future<void> loadData() async {
    final response = await RecommendProvider.resource();
    if (response.code != 200) {
      Get.snackbar('获取推荐歌单失败', response.msg!);
      return;
    }
    _playlists = response.recommend;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  bool get show => false;

  @override
  BorderRadius get borderRadius => const BorderRadius.only(
      topLeft: Radius.circular(16), topRight: Radius.circular(16));

  @override
  String get heroTag => "index_page_playing_bar";

  @override
  Widget buildPageBody(BuildContext context) {
    return ListView.builder(
      itemCount: _playlists.length,
      itemBuilder: (context, index) {
        final playlist = _playlists[index];
        return PlaylistTile(
          playlist: playlist,
          onTap: () {
            Get.to(() => PlaylistDetailPage(
                  playlistId: playlist.id,
                  heroTag: heroTag,
                ));
          },
        );
      },
    );
  }
}
