import 'package:flutter/material.dart';

import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/models/album.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class SearchAlbumTile extends StatelessWidget {
  final Album album;
  final GestureTapCallback? onTap;
  const SearchAlbumTile({
    Key? key,
    required this.album,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: FixImage(
          imageUrl: formatMusicImageUrl(album.picUrl, width: 64, height: 64),
          width: 64,
          height: 64,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        album.name,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      subtitle: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            album.artists?.map((e) => e.name).join("/") ?? "",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          (album.containedSong == null || album.containedSong == "")
              ? const SizedBox.shrink()
              : Text(" 包含单曲: ${album.containedSong}"),
        ],
      ),
      onTap: onTap,
    );
  }
}
