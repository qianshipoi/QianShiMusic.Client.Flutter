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
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: FixImage(
          imageUrl: formatMusicImageUrl(video.cover, width: 200, height: 112),
          width: 200,
          height: 112,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        video.name,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            video.artistName,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text("${formatPlaycount(video.playCount)}播放"),
        ],
      ),
      onTap: onTap,
    );
  }
}
