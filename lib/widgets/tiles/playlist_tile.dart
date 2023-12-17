import 'package:flutter/material.dart';

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
      title: Text(
        playlist.name.value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Text("${playlist.trackCount}首"),
          if (playlist.playCount != 0)
            Text(' · ${formatPlayCount(playlist.playCount)}次播放'),
          if (playlist.creator != null)
            Expanded(
                child: Text(
              ' · ${playlist.creator!.nickname}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )),
        ],
      ),
      trailing: onMoreTap == null
          ? null
          : IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: onMoreTap,
            ),
      onTap: onTap,
    );
  }

  String formatPlayCount(int playcount) {
    if (playcount > 10000) {
      return "${(playcount / 10000).toStringAsFixed(1)}万";
    }
    return playcount.toString();
  }
}
