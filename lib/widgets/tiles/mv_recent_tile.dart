import 'package:flutter/material.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/models/responses/record/record_recent_response.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class MvRecentTile extends StatelessWidget {
  final RecordRecentMv video;
  final GestureTapCallback? onTap;
  const MvRecentTile({
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
                imageUrl: formatMusicImageUrl(video.coverUrl),
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
                      video.name,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      maxLines: 2,
                    ),
                    Text("时长:${video.duration}"),
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
