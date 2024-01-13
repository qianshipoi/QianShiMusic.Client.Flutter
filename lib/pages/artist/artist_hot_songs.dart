import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qianshi_music/models/artist.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/pages/artist/artist_all_song_page.dart';
import 'package:qianshi_music/pages/play_song/play_song_page.dart';
import 'package:qianshi_music/provider/artist_provider.dart';
import 'package:qianshi_music/stores/playing_controller.dart';
import 'package:qianshi_music/widgets/tiles/track_tile.dart';

class ArtistHotSongs extends StatefulWidget {
  final Artist artist;
  const ArtistHotSongs({
    Key? key,
    required this.artist,
  }) : super(key: key);

  @override
  State<ArtistHotSongs> createState() => _ArtistHotSongsState();
}

class _ArtistHotSongsState extends State<ArtistHotSongs> {
  final PlayingController _playingController = Get.find();
  final _tracks = <Track>[];
  bool _loading = true;
  bool _more = false;

  Future _onLoading() async {
    try {
      final response = await ArtistProvider.topSongs(widget.artist.id);
      if (response.code != 200) {
        Get.snackbar("获取歌手热门歌曲失败", response.msg!);
        return;
      }
      _tracks.addAll(response.songs);
      _more = response.more;
      setState(() {});
    } finally {
      _loading = false;
      setState(() {});
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
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTrackListView(),
          if (_more)
            ElevatedButton(
              onPressed: () {
                Get.to(() => ArtistAllSongPage(artist: widget.artist));
              },
              child: const Text('全部歌曲'),
            ),
        ],
      ),
    );
  }

  ListView _buildTrackListView() {
    return ListView.builder(
      shrinkWrap: true,
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
    );
  }
}
