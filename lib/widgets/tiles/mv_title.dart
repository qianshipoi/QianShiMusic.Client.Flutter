import 'package:flutter/material.dart';

import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/models/mv.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class MvTile extends StatelessWidget {
  final Mv video;
  final GestureTapCallback? onTap;
  const MvTile({
    Key? key,
    required this.video,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FixImage(
                imageUrl: formatMusicImageUrl(video.cover),
                width: 160,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.name,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      video.artistName,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines: 2,
                    ),
                    Text("${formatPlaycount(video.playCount)}播放"),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
