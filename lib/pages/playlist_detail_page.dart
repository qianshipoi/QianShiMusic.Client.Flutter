// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/pages/base_playing_state.dart';
import 'package:qianshi_music/pages/play_song/play_song_page.dart';
import 'package:qianshi_music/stores/playing_controller.dart';
import 'package:qianshi_music/utils/http/http_util.dart';
import 'package:qianshi_music/widgets/fix_image.dart';
import 'package:qianshi_music/widgets/track_tile.dart';

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
    final playlist = Playlist.fromMap(response.data['playlist']);
    return playlist;
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
                      onTap: () async {
                        await _playingController.load(track);
                        await _playingController.play();
                        await Get.to(() => const PlaySongPage(),
                            arguments: track.id);
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
