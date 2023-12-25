import 'package:flutter/material.dart';
import 'package:qianshi_music/models/album.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class AlbumTile extends StatelessWidget {
  final Album album;
  final GestureTapCallback? onTap;
  final GestureTapCallback? onMoreTap;
  const AlbumTile({
    Key? key,
    required this.album,
    this.onTap,
    this.onMoreTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: FixImage(
          imageUrl: "${album.picUrl}?param=48y48",
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
        ),
      ),
      title: Text(
        album.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Text("${album.size}首"),
          if (album.artists.isNotEmpty)
            Expanded(
                child: Text(
              ' · ${album.artists.map((e) => e.name).join(' / ')}',
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
