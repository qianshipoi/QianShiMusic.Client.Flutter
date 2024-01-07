import 'package:flutter/material.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/models/responses/cloud/user_cloud_response.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class PrivateCloudTile extends StatelessWidget {
  final PrivateCloud privateCloud;
  final void Function()? onTap;
  final void Function()? onMoreTap;
  final int? index;
  const PrivateCloudTile({
    super.key,
    required this.privateCloud,
    this.onTap,
    this.onMoreTap,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildCover(context),
      title: Text(
        privateCloud.songName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        privateCloud.artist,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: onTap,
      trailing: _buildTrailing(),
    );
  }

  Widget? _buildCover(BuildContext context) {
    if (index != null) {
      return Text(
        "${index! + 1}",
        style: Theme.of(context).textTheme.bodyLarge,
      );
    }
    final coverUrl = privateCloud.simpleSong.album?.picUrl;
    if (coverUrl == null || coverUrl.isEmpty) {
      if (index == null) return null;
      return Text(
        "${index! + 1}",
        style: Theme.of(context).textTheme.bodyLarge,
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: FixImage(
        imageUrl: formatMusicImageUrl(coverUrl, size: 48),
        width: 48,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildTrailing() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        onMoreTap == null
            ? const SizedBox.shrink()
            : IconButton(
                onPressed: onMoreTap,
                icon: const Icon(Icons.more_vert),
              ),
      ],
    );
  }
}
