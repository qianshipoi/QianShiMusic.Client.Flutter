import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/constants.dart';

import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/widgets/add_to_playlist_view.dart';
import 'package:qianshi_music/widgets/comment/comment_view.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class TrackBottomSheet extends StatefulWidget {
  final Track track;
  const TrackBottomSheet({
    Key? key,
    required this.track,
  }) : super(key: key);

  @override
  State<TrackBottomSheet> createState() => _TrackBottomSheetState();
}

class _TrackBottomSheetState extends State<TrackBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final track = widget.track;
    return Column(
      children: [
        ListTile(
          leading: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            child: FixImage(
              imageUrl:
                  formatMusicImageUrl(widget.track.album.picUrl, size: 48),
              width: 48,
            ),
          ),
          title: Text(
            widget.track.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(widget.track.artists.map((e) => e.name).join('/')),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView(
            itemExtent: 48,
            children: [
              _buildAction(context, "下一首播放",
                  icon: const Icon(
                    Icons.play_arrow,
                    size: 20,
                  )),
              _buildAction(
                context,
                "收藏到歌单",
                icon: const Icon(
                  Icons.add_box_outlined,
                  size: 20,
                ),
                onTap: () {
                  Get.back();
                  Get.bottomSheet(
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AddToPlaylistView(track: track),
                    ),
                    backgroundColor: Theme.of(context).cardColor,
                  );
                },
              ),
              _buildAction(context, "下载",
                  icon: const Icon(
                    Icons.file_download,
                    size: 20,
                  )),
              _buildAction(
                context,
                "评论",
                icon: const Icon(
                  Icons.comment,
                  size: 20,
                ),
                onTap: () {
                  Get.bottomSheet(
                    Scaffold(
                        appBar: AppBar(title: const Text("评论")),
                        body: CommentView(type: 0, id: track.id)),
                    backgroundColor: Theme.of(context).colorScheme.background,
                    isScrollControlled: true,
                    ignoreSafeArea: false,
                  );
                },
              ),
              _buildAction(
                  context, '歌手: ${track.artists.map((e) => e.name).join('/')}',
                  icon: const Icon(
                    Icons.person,
                    size: 20,
                  )),
              _buildAction(context, '所属专辑: ${track.album.name}',
                  icon: const Icon(
                    Icons.album,
                    size: 20,
                  )),
              _buildAction(context, "相似歌曲", icon: const Icon(Icons.equalizer)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAction(BuildContext context, String title,
      {Widget? icon, GestureTapCallback? onTap}) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: onTap,
    );
  }
}
