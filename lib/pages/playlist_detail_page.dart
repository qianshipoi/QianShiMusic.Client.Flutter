import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qianshi_music/constants.dart';

import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/pages/base_playing_state.dart';
import 'package:qianshi_music/pages/play_song/play_song_page.dart';
import 'package:qianshi_music/provider/playlist_provider.dart';
import 'package:qianshi_music/stores/current_user_controller.dart';
import 'package:qianshi_music/stores/playing_controller.dart';
import 'package:qianshi_music/utils/logger.dart';
import 'package:qianshi_music/widgets/comment/comment_view.dart';
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
  final CurrentUserController _currentUserController = Get.find();
  final _refreshController = RefreshController(initialRefresh: false);
  Playlist? playlist;
  final _tracks = <Track>[].obs;
  bool _more = true;
  int _offset = 0;
  final _limit = 20;

  Future _onLoading() async {
    if (!_more || playlist == null) {
      _refreshController.loadNoData();
      return;
    }
    final response = await PlaylistProvider.trackAll(widget.playlistId,
        offset: _offset, limit: _limit);
    if (response.code != 200) {
      Get.snackbar("获取歌曲失败", response.msg!);
      return;
    }
    _tracks.addAll(response.songs);
    _offset = _tracks.length;
    _more = _tracks.length < playlist!.trackCount;
    _refreshController.loadComplete();
    if (!_more) {
      _refreshController.loadNoData();
    }
  }

  Future<Playlist> _getPlaylistDetail() async {
    if (_currentUserController.userPlaylist.isNotEmpty) {
      final playlist = _currentUserController.userPlaylist.firstOrNull;
      if (playlist != null && playlist.id == widget.playlistId) {
        if (playlist.tracks.isEmpty) {
          playlist.tracks.addAll(_currentUserController.userFavorite);
        }
        _tracks.addAll(playlist.tracks);
        this.playlist = playlist;
        _offset = _tracks.length;
        return playlist;
      }
    }

    final response = await PlaylistProvider.detail(widget.playlistId);
    playlist = response.playlist!;
    _tracks.addAll(response.playlist!.tracks);
    _offset = _tracks.length;
    logger.i('pla__offset:$_offset');
    return response.playlist!;
  }

  @override
  String get heroTag => widget.heroTag ?? "playlist_detail_page_playing_bar";

  @override
  Widget buildPageBody(BuildContext context) {
    return FutureBuilder(
      future: _getPlaylistDetail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final playlist = snapshot.data as Playlist;
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                _buildAppBar(playlist, context),
                _buildDetail(playlist),
              ];
            },
            body: Obx(() => _buildTrackListView(playlist)),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  SliverAppBar _buildAppBar(Playlist playlist, BuildContext context) {
    return SliverAppBar(
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
    );
  }

  SliverToBoxAdapter _buildDetail(Playlist playlist) {
    return SliverToBoxAdapter(
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
                  onPressed: () {
                    Get.bottomSheet(
                      CommentView(
                        id: playlist.id,
                        type: 2,
                      ),
                      backgroundColor: Theme.of(context).colorScheme.background,
                    );
                  },
                  icon: const Icon(Icons.comment_outlined),
                  label: Text(formatPlaycount(playlist.commentCount)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: Text(formatPlaycount(playlist.subscribedCount)),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
    );
  }

  SmartRefresher _buildTrackListView(Playlist playlist) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      enablePullDown: false,
      onLoading: _onLoading,
      child: ListView.builder(
        itemCount: _tracks.length,
        itemBuilder: (context, index) {
          final track = _tracks[index];
          return TrackTile(
            track: track,
            index: index,
            onTap: () async {
              if (await _playingController.addPlaylist(playlist,
                  playNow: true, playTrackId: track.id)) {
                await Get.to(() => const PlaySongPage(), arguments: track.id);
              }
            },
          );
        },
      ),
    );
  }
}
