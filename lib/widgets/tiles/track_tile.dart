import 'package:flutter/material.dart';

import 'package:qianshi_music/models/track.dart';

class TrackTile extends StatelessWidget {
  final Track track;
  final void Function()? onTap;
  final void Function()? onMoreTap;
  final int? index;
  const TrackTile({
    Key? key,
    required this.track,
    this.onTap,
    this.onMoreTap,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (index != null) {
      return ListTile(
        leading: Text(
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
        trailing: onMoreTap == null
            ? null
            : IconButton(
                onPressed: onMoreTap,
                icon: const Icon(Icons.more_vert),
              ),
      );
    }

    return ListTile(
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
      trailing: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.more_vert),
      ),
    );
  }
}
