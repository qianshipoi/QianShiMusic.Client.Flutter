import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class PlaylistTile extends StatelessWidget {
  final Playlist playlist;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onMoreTap;
  const PlaylistTile({
    Key? key,
    required this.playlist,
    this.onTap,
    this.onMoreTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FixImage(
          imageUrl: "${playlist.coverImgUrl}?param=48y48",
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
        ),
      ),
      title: Obx(() => Text(
            playlist.name.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )),
      subtitle: Text(subtitle()),
      trailing: onMoreTap == null
          ? null
          : IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: onMoreTap,
            ),
      onTap: onTap,
    );
  }

  String subtitle() {
    final list = <String>[];
    if (playlist.trackCount.value != 0) {
      list.add("${playlist.trackCount.value}首");
    }
    if (playlist.playCount != 0) {
      list.add('${formatPlayCount(playlist.playCount)}次播放');
    }
    if (playlist.creator != null) {
      list.add(playlist.creator!.nickname);
    }
    return list.join(' · ');
  }

  String formatPlayCount(int playcount) {
    if (playcount > 10000) {
      return "${(playcount / 10000).toStringAsFixed(1)}万";
    }
    return playcount.toString();
  }
}
