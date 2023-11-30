import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/pages/play_song/play_song_page.dart';
import 'package:qianshi_music/utils/http/http_util.dart';
import 'package:qianshi_music/widgets/fix_image.dart';
import 'package:qianshi_music/widgets/track_tile.dart';

class PlaylistDetailPage extends StatefulWidget {
  const PlaylistDetailPage({super.key});

  @override
  State<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  final int playlistId = Get.arguments;

  Future<Playlist> getPlaylistDetail() async {
    final response = await HttpUtils.get('playlist/detail?id=$playlistId');
    final playlist = Playlist.fromMap(response.data['playlist']);
    return playlist;
  }

  @override
  void initState() {
    super.initState();
    getPlaylistDetail();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPlaylistDetail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final playlist = snapshot.data as Playlist;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 230.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    playlist.name,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  background: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 0.0),
                    child: Opacity(
                      opacity: 0.5,
                      child: FixImage(
                        imageUrl: playlist.coverImgUrl,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
              ),
              SliverFixedExtentList(
                  itemExtent: 40,
                  delegate: SliverChildListDelegate(
                    [
                      Text(playlist.description ?? ""),
                      Text(playlist.playCount.toString()),
                    ],
                  )),
              SliverList(
                delegate: SliverChildBuilderDelegate((content, index) {
                  final track = playlist.tracks![index];
                  return TrackTile(
                      track: track,
                      index: index,
                      onTap: () => Get.to(() => const PlaySongPage(),
                          arguments: track.id));
                }, childCount: playlist.tracks!.length),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
