import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:qianshi_music/models/artist.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/pages/play_song/play_song_page.dart';
import 'package:qianshi_music/provider/artist_provider.dart';
import 'package:qianshi_music/stores/playing_controller.dart';
import 'package:qianshi_music/widgets/tiles/track_tile.dart';

class ArtistAllSongPage extends StatefulWidget {
  final Artist artist;
  const ArtistAllSongPage({
    Key? key,
    required this.artist,
  }) : super(key: key);

  @override
  State<ArtistAllSongPage> createState() => _ArtistAllSongPageState();
}

class _ArtistAllSongPageState extends State<ArtistAllSongPage> {
  final PlayingController _playingController = Get.find();
  final _refreshController = RefreshController(initialRefresh: false);
  final _tracks = <Track>[];
  bool _more = true;
  int _offset = 0;
  final _limit = 20;

  Future _onLoading() async {
    if (!_more) {
      _refreshController.loadNoData();
      return;
    }
    try {
      final response = await ArtistProvider.songs(widget.artist.id,
          offset: _offset, limit: _limit);
      if (response.code != 200) {
        Get.snackbar("获取歌手专辑失败", response.msg!);
        return;
      }
      _tracks.addAll(response.songs);
      _offset = _tracks.length;
      _more = response.more;
      _refreshController.loadComplete();
      setState(() {});
    } finally {
      if (!_more) {
        _refreshController.loadNoData();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      _onLoading();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTrackListView();
  }

  SmartRefresher _buildTrackListView() {
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
            onTap: () {
              _playingController.addTracks(_tracks, palyNowIndex: index);
              Get.to(() => PlaySongPage.instance);
            },
          );
        },
      ),
    );
  }
}
