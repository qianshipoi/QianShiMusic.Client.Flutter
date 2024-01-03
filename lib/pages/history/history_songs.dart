import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/pages/play_song/play_song_page.dart';
import 'package:qianshi_music/provider/record_provider.dart';
import 'package:qianshi_music/stores/playing_controller.dart';
import 'package:qianshi_music/widgets/tiles/track_tile.dart';
import 'package:qianshi_music/widgets/track_bottom_sheet.dart';

class HistorySongs extends StatefulWidget {
  const HistorySongs({super.key});

  @override
  State<HistorySongs> createState() => _HistorySongsState();
}

class _HistorySongsState extends State<HistorySongs> {
  final List<Track> _tracks = [];
  final _playingController = Get.find<PlayingController>();

  Future _onLoading() async {
    final response = await RecordProvider.recentSong();
    if (response.code != 200) {
      Get.snackbar("获取历史歌曲失败", response.msg!);
      return;
    }
    _tracks.addAll(response.data!.list.map((e) => Track.fromMap(e.data)));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _onLoading();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _tracks.length,
      itemBuilder: (context, index) {
        final track = _tracks[index];
        return TrackTile(
          track: track,
          index: index,
          onTap: () async {
            _playingController.addTrack(track, playNow: true);
            Get.to(() => PlaySongPage.instance);
          },
          onMoreTap: () {
            Get.bottomSheet(TrackBottomSheet(track: track),
                backgroundColor: Theme.of(context).colorScheme.background);
          },
        );
      },
    );
  }
}
