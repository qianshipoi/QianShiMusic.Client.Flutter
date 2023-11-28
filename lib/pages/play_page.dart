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
      appBar: AppBar(
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.5),
            Colors.black,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
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
      child: Container(color: Colors.black),
    );
  }

  Widget _buildImageView(BuildContext context, Track track) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: ClipOval(
            child: Opacity(
              opacity: 0.5,
              child: Container(
                height: 180,
                width: 360,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        Center(
          child: ClipOval(
            child: Opacity(
              opacity: 0.7,
              child: Container(
                height: 240,
                width: 330,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(150),
            child: FixImage(
              imageUrl: formatMusicImageUrl(track.album.picUrl!, size: 400),
              width: 300,
              height: 300,
              fit: BoxFit.cover,
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
        borderRadius: BorderRadius.circular(12),
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
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Text(
            track.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            track.artists.map((e) => e.name).join("/"),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
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
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  )),
              const SizedBox(width: 10),
              Text(
                formatTrackTime(track.dt),
                style: const TextStyle(
                  color: Colors.white,
                ),
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
            icon: const Icon(Icons.skip_previous),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
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
