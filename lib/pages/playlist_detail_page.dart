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
import 'package:qianshi_music/widgets/description/description_dialog.dart';
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
    _more = _tracks.length < playlist!.trackCount.value;
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
      title: Text(
        playlist.name.value,
        style: TextStyle(
            overflow: TextOverflow.ellipsis,
            color: Theme.of(context).colorScheme.onBackground),
      ),
      expandedHeight: 230.0,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildProfile(),
      ),
    );
  }

  Widget _buildProfile() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: FixImage(
              imageUrl: playlist!.coverImgUrl.value,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.0),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Row(
                children: [
                  FixImage(
                    imageUrl: playlist!.creator!.avatarUrl,
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playlist!.creator!.nickname,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          formatPlaycount(playlist!.playCount),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      _playingController.addPlaylist(playlist!,
                          playTrackId: playlist!.tracks.first.id);
                      Get.to(() => PlaySongPage.instance);
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("播放全部"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildDetail(Playlist playlist) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(
            height: 42,
            child: ListTile(
              onTap: () {
                Get.bottomSheet(
                  Description(descrition: playlist.description.value ?? ""),
                  backgroundColor: Theme.of(context).colorScheme.background,
                );
              },
              title: Text(
                playlist.description.value ?? "",
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
                  onPressed: _currentUserController.isMyCreated(playlist)
                      ? null
                      : () async {
                          bool result = true;

                          if (playlist.subscribed.value) {
                            // cancel subscribe
                            result = (await Get.dialog<bool>(AlertDialog(
                                  title: const Text("确定不再收藏此歌单吗？"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text("取消"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back(result: true);
                                      },
                                      child: const Text("确定"),
                                    ),
                                  ],
                                ))) ??
                                false;
                          }
                          if (!result) {
                            return;
                          }

                          final response = await PlaylistProvider.subscribe(
                              playlist.id, !playlist.subscribed.value);
                          if (response.code == 200) {
                            playlist.subscribed.value =
                                !playlist.subscribed.value;
                            if (!playlist.subscribed.value) {
                              _currentUserController.favoritePlaylist
                                  .removeWhere(
                                      (element) => element.id == playlist.id);
                            }
                          }
                        },
                  icon: Obx(() => Icon(
                        playlist.subscribed.value
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: playlist.subscribed.value
                            ? Colors.red
                            : Theme.of(context).colorScheme.onBackground,
                      )),
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
              _playingController.addPlaylist(playlist,
                  playNow: true, playTrackId: track.id);
              Get.to(() => PlaySongPage.instance);
            },
          );
        },
      ),
    );
  }
}
