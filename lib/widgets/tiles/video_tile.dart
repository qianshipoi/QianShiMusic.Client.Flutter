import 'package:flutter/material.dart';

import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/models/video.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class VideoTile extends StatelessWidget {
  final Video video;
  final GestureTapCallback? onTap;
  const VideoTile({
    Key? key,
    required this.video,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: FixImage(
          imageUrl:
              formatMusicImageUrl(video.coverUrl, width: 200, height: 112),
          width: 200,
          height: 112,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        video.title,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            video.creator.map((e) => e.userName).join("/"),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text("${formatPlaycount(video.playTime)}播放"),
        ],
      ),
      onTap: onTap,
    );
  }
}
