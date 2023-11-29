import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/provider/track_provider.dart';
import 'package:qianshi_music/stores/playing_controller.dart';
import 'package:qianshi_music/utils/logger.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({super.key});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  bool _showLyric = false;
  final int _trackId = Get.arguments;
  final PlayingController _playingController = Get.find();

  Future<Track?> _getTrack() async {
    final response = await SongProvider.detail(_trackId.toString());
    if (response.code == 200) {
      return response.songs!.first;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 187, 230, 243),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Now Playing"),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder(
          future: _getTrack(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final track = snapshot.data as Track;
              return GestureDetector(
                onHorizontalDragStart: (details) {
                  logger.d("onHorizontalDragStart: ${details.globalPosition}");
                },
                onHorizontalDragUpdate: (details) {
                  logger.d("onHorizontalDragUpdate: ${details.globalPosition}");
                },
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity == null) {
                    return;
                  }
                  if (details.primaryVelocity! > 200) {
                    logger.i('上一曲');
                  } else if (details.primaryVelocity! < -200) {
                    logger.i('下一曲');
                  }
                },
                onTap: () => setState(() => _showLyric = !_showLyric),
                child: _showLyric
                    ? _buildLyricView(context, track)
                    : _buildMainView(context, track),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget _buildMainView(BuildContext context, Track track) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(48),
            topRight: Radius.circular(48),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildImageView(context, track),
          _buildCenterView(context, track),
          _buildBottomView(context, track),
        ],
      ),
    );
  }

  Widget _buildLyricView(BuildContext context, Track track) {
    return Expanded(
      child: Container(
        color: Colors.transparent,
      ),
    );
  }

  Widget _buildImageView(BuildContext context, Track track) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: ClipOval(
            child: Opacity(
              opacity: 0.2,
              child: Container(
                height: 180,
                width: 320,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        Center(
          child: ClipOval(
            child: Opacity(
              opacity: 0.5,
              child: Container(
                height: 240,
                width: 290,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: 4,
              ),
              color: Theme.of(context).primaryColor,
            ),
            child: ClipOval(
              child: FixImage(
                imageUrl: formatMusicImageUrl(track.album.picUrl!, size: 260),
                width: 260,
                height: 260,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Center(child: _buildPlayButton(context, track))
      ],
    );
  }

  Widget _buildPlayButton(BuildContext context, Track track) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: IconButton(
        icon: Obx(
          () => Icon(
            _playingController.isPlaying.value ? Icons.pause : Icons.play_arrow,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        onPressed: () {
          if (_playingController.isPlaying.value) {
            _playingController.pause();
          } else {
            _playingController.play(track);
          }
        },
      ),
    );
  }

  Widget _buildCenterView(BuildContext context, Track track) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            track.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            track.artists.map((e) => e.name).join("/"),
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Center(
              child: Obx(
            () => Slider(
                max: track.dt.toDouble(),
                value: _playingController.currentPosition.value.toDouble(),
                onChanged: (value) {
                  logger.d("onChanged: $value");
                  _playingController.seekTo(value.toInt());
                }),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => Text(
                    formatTrackTime(_playingController.currentPosition.value),
                  )),
              const SizedBox(width: 10),
              Text(
                formatTrackTime(track.dt),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomView(BuildContext context, Track track) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.post_add),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border_outlined),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  String formatTrackTime(int time) {
    final duration = Duration(milliseconds: time);
    final minutes = duration.inMinutes.toString().padLeft(2, "0");
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, "0");
    return "$minutes:$seconds";
  }
}
