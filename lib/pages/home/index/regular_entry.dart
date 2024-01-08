import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/pages/daily_songs_page.dart';
import 'package:qianshi_music/pages/play_song/play_song_page.dart';
import 'package:qianshi_music/pages/playlist_page.dart';
import 'package:qianshi_music/pages/toplist_page.dart';
import 'package:qianshi_music/stores/playing_controller.dart';

class RegularEnter extends StatelessWidget {
  const RegularEnter({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.68,
        ),
        children: [
          IconButton.filled(
            style: buttonStyle,
            onPressed: () => Get.to(() => const DailySongsPage()),
            icon: const Icon(Icons.date_range),
          ),
          IconButton.filled(
            style: buttonStyle,
            onPressed: () {
              final playingController = Get.find<PlayingController>();
              playingController.playFm();
              Get.to(() => PlaySongPage.instance);
            },
            icon: const Icon(Icons.radio),
          ),
          IconButton.filled(
            style: buttonStyle,
            onPressed: () => Get.to(() => const PlaylistPage()),
            icon: const Icon(Icons.my_library_music),
          ),
          IconButton.filled(
            style: buttonStyle,
            onPressed: () => Get.to(() => const ToplistPage()),
            icon: const Icon(Icons.nature),
          ),
        ],
      ),
    );
  }
}
