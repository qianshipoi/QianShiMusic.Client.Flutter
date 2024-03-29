import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qianshi_music/models/responses/search/search_collect_response.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/pages/play_song/play_song_page.dart';
import 'package:qianshi_music/provider/search_provider.dart';
import 'package:qianshi_music/stores/playing_controller.dart';
import 'package:qianshi_music/widgets/tiles/track_tile.dart';

class SearchSongView extends StatefulWidget {
  final String keyword;
  const SearchSongView({
    Key? key,
    required this.keyword,
  }) : super(key: key);

  @override
  State<SearchSongView> createState() => _SearchSongViewState();
}

class _SearchSongViewState extends State<SearchSongView> {
  final List<Track> _songs = [];
  final _refreshController = RefreshController(initialRefresh: false);
  final PlayingController _playingController = Get.find();
  bool more = true;
  int limit = 20;
  int page = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshController.requestLoading();
    });
  }

  Future _onLoading() async {
    if (!more) {
      _refreshController.loadNoData();
      return;
    }
    final response = await SearchProvider.search(
        widget.keyword, MusicSearchType.song,
        limit: limit, offset: (page - 1) * limit);
    final result = response as SearchSongResponse;
    if (result.code != 200) {
      return;
    }
    _songs.addAll(result.result!.songs);
    more = response.result!.hasMore;
    page++;
    _refreshController.loadComplete();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullUp: true,
      enablePullDown: false,
      controller: _refreshController,
      onLoading: _onLoading,
      child: ListView.builder(
        itemCount: _songs.length,
        itemBuilder: (context, index) => TrackTile(
          track: _songs[index],
          index: index,
          onTap: () {
            _playingController.addTrack(_songs[index], playNow: true);
            Get.to(() => PlaySongPage.instance);
          },
        ),
      ),
    );
  }
}
