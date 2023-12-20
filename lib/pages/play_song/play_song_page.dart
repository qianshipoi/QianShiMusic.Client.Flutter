import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/pages/play_song/lyric_page.dart';
import 'package:qianshi_music/stores/playing_controller.dart';
import 'package:qianshi_music/utils/logger.dart';
import 'package:qianshi_music/widgets/fix_image.dart';
import 'package:qianshi_music/widgets/keep_alive_wrapper.dart';

class PlaySongPage extends StatefulWidget {
  static PlaySongPage? _instance;
  static Widget get instance {
    _instance ??= const PlaySongPage._internal();
    return _instance!;
  }

  const PlaySongPage._internal();

  @override
  State<PlaySongPage> createState() => _PlaySongPageState();
}

class _PlaySongPageState extends State<PlaySongPage>
    with SingleTickerProviderStateMixin {
  final PlayingController _playingController = Get.find();
  final _pageController = PageController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  double coverX = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final track = _playingController.currentTrack;
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
        body: Obx(
          () => track.value == null
              ? const Center(child: Text("No Track"))
              : Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(48),
                      topRight: Radius.circular(48),
                    ),
                  ),
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    children: [
                      _buildMainView(context, track.value!),
                      _buildLyricView(context, track.value!),
                    ],
                  ),
                ),
        ));
  }

  Widget _buildMainView(BuildContext context, Track track) {
    return KeepAliveWrapper(
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          coverX += details.delta.dx;
          setState(() {});
        },
        onHorizontalDragEnd: (details) {
          // 计算是否切换歌曲
          final screenWidth = ScreenUtil().screenWidth;
          final offsetX = coverX.abs();

          logger.i('screenWidth: $screenWidth, offsetX: $offsetX');

          if (screenWidth / 2 > offsetX + screenWidth / 4) {
            // 不切换 图片回到原位
            _animation = Tween(begin: coverX, end: 0.0).animate(CurvedAnimation(
                parent: _animationController, curve: Curves.bounceOut))
              ..addListener(() {
                coverX = _animation.value;
                setState(() {});
              });

            _animationController.reset();
            _animationController.forward();
            return;
          }

          if (coverX < 0) {
            _playingController.next();
          } else {
            _playingController.prev();
          }

          _animation = Tween(begin: coverX, end: 0.0).animate(CurvedAnimation(
              parent: _animationController, curve: Curves.bounceOut))
            ..addListener(() {
              coverX = _animation.value;
              setState(() {});
            });

          _animationController.reset();
          _animationController.forward();

          logger.i('切换到：${coverX < 0 ? '下一曲' : '上一曲'}');

          if (details.primaryVelocity == null) {
            return;
          }
          if (details.primaryVelocity! > 200) {
            logger.i('上一曲');
          } else if (details.primaryVelocity! < -200) {
            logger.i('下一曲');
          }
        },
        onTap: () => _pageController.jumpToPage(1),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildImageView(context, track),
              _buildCenterView(context, track),
              _buildBottomView(context, track),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLyricView(BuildContext context, Track track) {
    return KeepAliveWrapper(
        child: GestureDetector(
      onTap: () => _pageController.jumpToPage(0),
      child: LyricPage(trackId: track.id),
    ));
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
            child: Transform.translate(
              offset: Offset(coverX, 0),
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
            _playingController.play();
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
                    _formatTrackTime(_playingController.currentPosition.value),
                  )),
              const SizedBox(width: 10),
              Text(
                _formatTrackTime(track.dt),
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

  String _formatTrackTime(int time) {
    final duration = Duration(milliseconds: time);
    final minutes = duration.inMinutes.toString().padLeft(2, "0");
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, "0");
    return "$minutes:$seconds";
  }
}
