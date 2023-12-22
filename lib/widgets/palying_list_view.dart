import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/stores/playing_controller.dart';
import 'package:qianshi_music/widgets/tiles/track_tile.dart';

class PlayingListView extends StatefulWidget {
  const PlayingListView({super.key});

  @override
  State<PlayingListView> createState() => _PlayingListViewState();
}

class _PlayingListViewState extends State<PlayingListView> {
  final PlayingController _playingController = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _playingController.tracks.length,
      itemBuilder: (context, index) {
        final track = _playingController.tracks[index];
        return TrackTile(
          track: track,
          onTap: () {
            _playingController.play(index: index);
          },
        );
      },
    );
  }
}
