import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/constants.dart';

import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/pages/base_playing_state.dart';
import 'package:qianshi_music/pages/play_song/play_song_page.dart';
import 'package:qianshi_music/stores/playing_controller.dart';
import 'package:qianshi_music/utils/http/http_util.dart';
import 'package:qianshi_music/widgets/fix_image.dart';
import 'package:qianshi_music/widgets/tiles/track_tile.dart';

class PlaylistDetailPage extends StatefulWidget {
  final String? heroTag;
  final int playlistId;
  const PlaylistDetailPage({
    Key? key,
    this.heroTag,
    required this.playlistId,
  }) : super(key: key);

  @override
  State<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends BasePlayingState<PlaylistDetailPage> {
  final PlayingController _playingController = Get.find();

  Future<Playlist> getPlaylistDetail() async {
    final response =
        await HttpUtils.get('playlist/detail?id=${widget.playlistId}');
    return Playlist.fromMap(response.data['playlist']);
  }

  @override
  void initState() {
    super.initState();
    getPlaylistDetail();
  }

  @override
  String get heroTag => widget.heroTag ?? "playlist_detail_page_playing_bar";

  @override
  Widget buildPageBody(BuildContext context) {
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
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(
                      height: 32,
                      child: ListTile(
                        title: Text(
                          playlist.description ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.comment_outlined),
                            label: Text(formatPlaycount(playlist.commentCount)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.add),
                            label:
                                Text(formatPlaycount(playlist.subscribedCount)),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((content, index) {
                  final track = playlist.tracks![index];
                  return TrackTile(
                      track: track,
                      index: index,
                      onTap: () async {
                        if (await _playingController.addPlaylist(playlist,
                            playNow: true, playTrackId: track.id)) {
                          await Get.to(() => const PlaySongPage(),
                              arguments: track.id);
                        }
                      });
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
