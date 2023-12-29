import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/pages/video/mv_page.dart';
import 'package:qianshi_music/provider/index_provider.dart';
import 'package:qianshi_music/provider/mv_provider.dart';
import 'package:qianshi_music/provider/playlist_provider.dart';
import 'package:qianshi_music/stores/playing_controller.dart';
import 'package:qianshi_music/widgets/horizontal_title_list_view.dart';
import 'package:qianshi_music/widgets/tiles/track_tile.dart';

class RecommendSongs extends StatefulWidget {
  const RecommendSongs({super.key});

  @override
  State<RecommendSongs> createState() => _RecommendSongsState();
}

class _RecommendSongsState extends State<RecommendSongs> {
  final PlayingController _playingController = Get.find();
  final List<List<Track>> songs = [];
  Playlist? playlist;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
  }

  Future<void> loadData() async {
    final playlistResponse = await IndexProvider.personalized(limit: 1);
    if (playlistResponse.code != 200) {
      Get.snackbar('获取推荐歌单失败', playlistResponse.msg!);
      return;
    }
    playlist = playlistResponse.result[0];
    final playlistId = playlistResponse.result[0].id;

    final songsResponse = await PlaylistProvider.trackAll(playlistId, limit: 9);

    if (songsResponse.code != 200) {
      Get.snackbar('获取推荐歌单歌曲失败', songsResponse.msg!);
      return;
    }

    songs.addAll(chunked(songsResponse.songs, 3));

    setState(() {});
  }

  List<List<T>> chunked<T>(List<T> list, int size) {
    return List.generate((list.length / size).ceil(), (index) {
      int start = index * size;
      int end = start + size;
      return list.sublist(start, end > list.length ? list.length : end);
    });
  }

  @override
  Widget build(BuildContext context) {
    return playlist == null
        ? const SizedBox.shrink()
        : HorizontalTitleListView(
            title: playlist!.name.value,
            listView: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final songs = this.songs[index];
                return ListView.builder(
                  itemBuilder: (context, childIndex) {
                    final song = songs[childIndex];
                    return TrackTile(
                      track: song,
                      onTap: () {
                        int playNowIndex = 0;
                        for (var i = index - 1; i >= 0; i++) {
                          playNowIndex += this.songs[i].length;
                        }
                        playNowIndex += childIndex;

                        _playingController.addTracks(songs,
                            palyNowIndex: playNowIndex);
                      },
                      onMoreTap: song.mv == 0
                          ? null
                          : () async {
                              final mv = await MvProvider.detail(song.mv);
                              if (mv.code != 200) {
                                Get.snackbar('获取MV详情失败', mv.msg!);
                                return;
                              }
                              Get.to(() => MvPage(mv.data!));
                            },
                    );
                  },
                );
              },
            ),
          );
  }
}
