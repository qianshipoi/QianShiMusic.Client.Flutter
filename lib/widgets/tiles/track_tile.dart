import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/constants.dart';

import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/pages/video/mv_page.dart';
import 'package:qianshi_music/provider/mv_provider.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class TrackTile extends StatelessWidget {
  final Track track;
  final void Function()? onTap;
  final void Function()? onMoreTap;
  final int? index;
  const TrackTile({
    super.key,
    required this.track,
    this.onTap,
    this.onMoreTap,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildCover(context),
      title: Text(
        track.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        track.artists.map((e) => e.name).join('/'),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
      trailing: _buildTrailing(),
    );
  }

  Widget? _buildCover(BuildContext context) {
    if (track.album.picUrl == null || track.album.picUrl!.isEmpty) {
      if (index == null) {
        return null;
      }
      return Text(
        "${index! + 1}",
        style: Theme.of(context).textTheme.bodyLarge,
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: FixImage(
        imageUrl: formatMusicImageUrl(track.album.picUrl!, size: 48),
        width: 48,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildTrailing() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMvBotton(),
        onMoreTap == null
            ? const SizedBox.shrink()
            : IconButton(
                onPressed: onMoreTap,
                icon: const Icon(Icons.more_vert),
              ),
      ],
    );
  }

  Widget _buildMvBotton() {
    if (track.mv == 0) {
      return const SizedBox.shrink();
    }
    return IconButton(
      onPressed: () async {
        final mv = await MvProvider.detail(track.mv);
        if (mv.code != 200) {
          Get.snackbar('获取MV详情失败', mv.msg!);
          return;
        }
        Get.to(() => MvPage(mv: mv.data!));
      },
      icon: const Icon(Icons.video_collection_outlined),
    );
  }
}
