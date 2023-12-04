import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/constants.dart';

import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/pages/base_playing_state.dart';
import 'package:qianshi_music/utils/http/http_util.dart';
import 'package:qianshi_music/widgets/tiles/playlist_tile.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends BasePlayingState<IndexPage> {
  List<Playlist> _playlists = [];

  Future<void> loadData() async {
    final response = await HttpUtils.get('top/playlist/highquality');
    final result = response.data as Map<String, dynamic>;

    if (result['code'] == 200) {
      final List<dynamic> playlists = result['playlists'] as List<dynamic>;
      _playlists = playlists
          .map((e) => Playlist.fromMap(e as Map<String, dynamic>))
          .toList();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

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
            Get.toNamed(RouterContants.playlistDetail, arguments: {
              "playlistId": playlist.id,
              "heroTag": heroTag,
            });
          },
        );
      },
    );
  }

  String formatPlayCount(int playcount) {
    if (playcount > 10000) {
      return "${(playcount / 10000).toStringAsFixed(1)}万";
    }
    return playcount.toString();
  }
}
