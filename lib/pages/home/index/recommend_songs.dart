import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/provider/index_provider.dart';
import 'package:qianshi_music/provider/playlist_provider.dart';
import 'package:qianshi_music/stores/playing_controller.dart';
import 'package:qianshi_music/widgets/tiles/track_tile.dart';

class RecommendSongs extends StatefulWidget {
  const RecommendSongs({super.key});

  @override
  State<RecommendSongs> createState() => _RecommendSongsState();
}

class _RecommendSongsState extends State<RecommendSongs>
    with TickerProviderStateMixin {
  final PlayingController _playingController = Get.find();
  final List<Track> _allTracks = [];
  final List<List<Track>> songs = [];
  TabController? _tabController;
  Playlist? playlist;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    final playlistResponse = await IndexProvider.personalized(limit: 1);
    if (playlistResponse.code != 200) {
      Get.snackbar('获取推荐歌单失败', playlistResponse.msg!);
      return;
    }
    playlist = playlistResponse.result[0];
    final playlistId = playlistResponse.result[0].id;

    final songsResponse =
        await PlaylistProvider.trackAll(playlistId, limit: 12);

    if (songsResponse.code != 200) {
      Get.snackbar('获取推荐歌单歌曲失败', songsResponse.msg!);
      return;
    }
    songs.clear();
    songs.addAll(chunked(songsResponse.songs, 3));
    _tabController?.dispose();

    _tabController = TabController(length: songs.length, vsync: this);

    _allTracks.clear();
    _allTracks.addAll(songsResponse.songs);

    setState(() {});
  }

  List<List<T>> chunked<T>(List<T> list, int size) {
    return List.generate((list.length / size).ceil(), (index) {
      int start = index * size;
      int end = start + size;
      return list.sublist(start, end > list.length ? list.length : end);
    });
  }

  void play({int index = 0}) {
    _playingController.addTracks(_allTracks, palyNowIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return playlist == null
        ? const SizedBox.shrink()
        : SizedBox(
            height: 380,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: loadData,
                      icon: const Icon(Icons.refresh),
                    ),
                    Expanded(
                        child: Text(
                      playlist!.name.value,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                    IconButton(
                      onPressed: play,
                      icon: const Icon(Icons.play_arrow),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    viewportFraction: 0.9,
                    controller: _tabController,
                    children: songs.map((songs) {
                      return SizedBox(
                        width: ScreenUtil().screenWidth - 30,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: songs.length,
                          itemBuilder: (context, childIndex) {
                            final song = songs[childIndex];
                            return TrackTile(
                              track: song,
                              onTap: () {
                                play(index: _allTracks.indexOf(song));
                              },
                            );
                          },
                        ),
                      );
                    }).toList(),

                    // scrollDirection: Axis.horizontal,
                    // itemCount: songs.length,
                    // itemBuilder: (context, index) {
                    //   final songs = this.songs[index];
                    //   return SizedBox(
                    //     width: ScreenUtil().screenWidth - 30,
                    //     child: ListView.builder(
                    //       physics: const NeverScrollableScrollPhysics(),
                    //       itemCount: songs.length,
                    //       itemBuilder: (context, childIndex) {
                    //         final song = songs[childIndex];
                    //         return TrackTile(
                    //           track: song,
                    //           onTap: () {
                    //             play(index: _allTracks.indexOf(song));
                    //           },
                    //         );
                    //       },
                    //     ),
                    //   );
                    // },
                  ),
                ),
              ],
            ),
          );
  }
}
