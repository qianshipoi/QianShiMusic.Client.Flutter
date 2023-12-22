import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/provider/playlist_provider.dart';
import 'package:qianshi_music/stores/current_user_controller.dart';
import 'package:qianshi_music/widgets/tiles/playlist_tile.dart';

class AddToPlaylistView extends StatefulWidget {
  final Track track;
  const AddToPlaylistView({
    Key? key,
    required this.track,
  }) : super(key: key);

  @override
  State<AddToPlaylistView> createState() => _AddToPlaylistViewState();
}

class _AddToPlaylistViewState extends State<AddToPlaylistView> {
  final CurrentUserController _currentUserController = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _currentUserController.createdPlaylist.length,
      itemBuilder: (context, index) {
        final playlist = _currentUserController.createdPlaylist[index];
        return PlaylistTile(
          playlist: playlist,
          onTap: () async {
            final response =
                await PlaylistProvider.tracks(playlist.id, [widget.track.id]);
            if (response.body.code != 200) {
              Get.back();
              Get.snackbar("添加到歌单失败", response.body.msg!);
              return;
            }
            playlist.trackCount.value++;
            Get.back();
            Get.snackbar("成功", "添加到歌单成功");
          },
        );
      },
    );
  }
}
