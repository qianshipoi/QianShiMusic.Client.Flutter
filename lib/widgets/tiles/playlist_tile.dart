import 'package:flutter/material.dart';

import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class PlaylistTile extends StatelessWidget {
  final Playlist playlist;
  final GestureTapCallback? onTap;
  const PlaylistTile({
    Key? key,
    required this.playlist,
    this.onTap,
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
        playlist.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        playlist.description ?? "",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(formatPlayCount(playlist.playCount)),
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
