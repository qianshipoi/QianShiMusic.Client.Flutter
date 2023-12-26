import 'package:flutter/material.dart';

import 'package:qianshi_music/models/track.dart';

class TrackTile extends StatelessWidget {
  final Track track;
  final void Function()? onTap;
  final void Function()? onMoreTap;
  final void Function()? onVideoTap;
  final int? index;
  const TrackTile({
    Key? key,
    required this.track,
    this.onTap,
    this.onMoreTap,
    this.onVideoTap,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: index == null
          ? null
          : Text(
              "${index! + 1}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
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

  Widget _buildTrailing() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        onVideoTap == null
            ? const SizedBox.shrink()
            : IconButton(
                onPressed: onVideoTap,
                icon: const Icon(Icons.video_collection_outlined),
              ),
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
