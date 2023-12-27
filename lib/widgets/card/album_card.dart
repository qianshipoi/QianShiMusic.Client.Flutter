import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/models/album.dart';

import 'package:qianshi_music/pages/playlist_detail_page.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class AlbumCard extends StatelessWidget {
  final Album album;
  const AlbumCard({
    Key? key,
    required this.album,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: GestureDetector(
        onTap: () {
          Get.to(() => PlaylistDetailPage(playlistId: album.id));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              child: FixImage(
                imageUrl: formatMusicImageUrl(album.picUrl, size: 160),
                width: 160,
                height: 160,
              ),
            ),
            Text(
              album.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
