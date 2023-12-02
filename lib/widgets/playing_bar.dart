// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/pages/play_song/play_song_page.dart';
import 'package:qianshi_music/stores/playing_controller.dart';
import 'package:qianshi_music/widgets/common_text_style.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class PlayingBar extends StatelessWidget {
  final String? tag;
  final BorderRadius? borderRadius;
  const PlayingBar({
    Key? key,
    this.tag,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<PlayingController>(
      builder: (controller) => controller.currentTrack != null
          ? Hero(
              tag: tag ?? DateTime.timestamp(),
              child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 187, 230, 243),
                    borderRadius: borderRadius ??
                        const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                  ),
                  child: ListTile(
                    splashColor: Colors.transparent,
                    leading: ClipOval(
                      child: FixImage(
                        imageUrl: formatMusicImageUrl(
                            controller.currentTrack!.album.picUrl,
                            size: 40),
                        width: 40,
                        height: 40,
                      ),
                    ),
                    title: Text(
                      controller.currentTrack!.name,
                      overflow: TextOverflow.ellipsis,
                      style: common13TextStyle,
                    ),
                    onTap: () async {
                      await Get.to(() => const PlaySongPage(),
                          arguments: controller.currentTrack!.id);
                    },
                    trailing: IconButton(
                      onPressed: () {
                        if (controller.isPlaying.value) {
                          controller.pause();
                        } else {
                          controller.resume();
                        }
                      },
                      icon: Icon(controller.isPlaying.value
                          ? Icons.pause
                          : Icons.play_arrow),
                    ),
                  )),
            )
          : const SizedBox.shrink(),
    );
  }
}
