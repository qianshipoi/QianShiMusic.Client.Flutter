import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/provider/recommend_provider.dart';
import 'package:qianshi_music/stores/playing_controller.dart';
import 'package:qianshi_music/widgets/tiles/track_tile.dart';

class DailySongsPage extends StatefulWidget {
  const DailySongsPage({super.key});

  @override
  State<DailySongsPage> createState() => _DailySongsPageState();
}

class _DailySongsPageState extends State<DailySongsPage> {
  final PlayingController _playingController = Get.find();
  final List<Track> _tracks = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
  }

  Future<void> loadData() async {
    final response = await RecommendProvider.songs();
    if (response.code != 200) {
      Get.snackbar('获取每日推荐歌曲失败', response.msg!);
      return;
    }
    _tracks.addAll(response.data!.dailySongs);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('每日推荐'),
      ),
      body: ListView.builder(
        itemCount: _tracks.length,
        itemBuilder: (context, index) {
          final track = _tracks[index];
          return TrackTile(
            track: track,
            onMoreTap: () {},
            onTap: () async {
              _playingController.addTracks(_tracks, palyNowIndex: index);
              
            },
          );
        },
      ),
    );
  }
}
