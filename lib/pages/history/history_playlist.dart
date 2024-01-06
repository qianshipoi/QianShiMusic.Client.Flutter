import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/pages/playlist_detail_page.dart';
import 'package:qianshi_music/provider/record_provider.dart';
import 'package:qianshi_music/widgets/tiles/playlist_tile.dart';

class HistoryPlaylist extends StatefulWidget {
  const HistoryPlaylist({super.key});

  @override
  State<HistoryPlaylist> createState() => _HistoryPlaylistState();
}

class _HistoryPlaylistState extends State<HistoryPlaylist> {
  final List<Playlist> _playlists = [];

  Future _onLoading() async {
    final response = await RecordProvider.recentPlaylist();
    if (response.code != 200) {
      Get.snackbar("获取历史歌单失败", response.msg!);
      return;
    }
    _playlists.addAll(response.data!.list.map((e) => Playlist.fromMap(e.data)));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _onLoading();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _playlists.length,
      itemBuilder: (context, index) {
        final playlist = _playlists[index];
        return PlaylistTile(
          playlist: playlist,
          onTap: () =>
              Get.to(() => PlaylistDetailPage(playlistId: playlist.id)),
        );
      },
    );
  }
}
