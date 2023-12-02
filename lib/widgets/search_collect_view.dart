import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/models/responses/search_collect_response.dart';
import 'package:qianshi_music/pages/play_song/play_song_page.dart';
import 'package:qianshi_music/provider/search_provider.dart';
import 'package:qianshi_music/stores/playing_controller.dart';
import 'package:qianshi_music/utils/logger.dart';
import 'package:qianshi_music/widgets/playlist_tile.dart';
import 'package:qianshi_music/widgets/track_tile.dart';

class SearchCollectView extends StatefulWidget {
  final String keyword;
  const SearchCollectView({
    Key? key,
    required this.keyword,
  }) : super(key: key);

  @override
  State<SearchCollectView> createState() => _SearchCollectViewState();
}

class _SearchCollectViewState extends State<SearchCollectView> {
  final PlayingController _playingController = Get.find();

  Future<SearchCollectResult> _onLoading() async {
    final response =
        await SearchProvider.search(widget.keyword, MusicSearchType.collect);
    final result = response as SearchCollectResponse;
    if (result.code != 200) {
      throw Exception(result.msg);
    }
    return result.result!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _onLoading(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        if (snapshot.hasData) {
          final result = snapshot.data as SearchCollectResult;
          List<Widget> children = [];
          if (result.song != null) {
            final songs = result.song!.songs;
            children.add(const ListTile(
              title: Text("单曲"),
            ));
            children.add(ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: songs.length,
              itemBuilder: (context, index) => TrackTile(
                  track: songs[index],
                  index: index,
                  onTap: () async {
                    await _playingController.load(songs[index]);
                    await _playingController.play();
                    await Get.to(() => const PlaySongPage(),
                        arguments: songs[index].id);
                  }),
            ));
            children.add(ListTile(
              title: Center(child: Text(result.song!.moreText)),
              onTap: () => logger.i("more song"),
            ));
            children.add(const Divider());
          }

          if (result.playList != null) {
            final playlists = result.playList!.playLists;
            children.add(const ListTile(
              title: Text("歌单"),
            ));
            children.add(ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: playlists.length,
              itemBuilder: (context, index) =>
                  PlaylistTile(playlist: playlists[index]),
            ));
            children.add(ListTile(
              title: Center(child: Text(result.playList!.moreText)),
              onTap: () => logger.i("more playlist"),
            ));
          }

          return ListView(children: children);
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
