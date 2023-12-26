import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:qianshi_music/widgets/video_player/video_player_utils.dart';

// ignore: must_be_immutable
class VideoPlayerTop extends StatefulWidget {
  Function(bool)? opacityCallback;
  final String title;
  VideoPlayerTop({
    Key? key,
    this.opacityCallback,
    required this.title,
  }) : super(key: key);

  @override
  State<VideoPlayerTop> createState() => _VideoPlayerTopState();
}

class _VideoPlayerTopState extends State<VideoPlayerTop> {
  double _opacity = TempValue.isLocked ? 0.0 : 1.0; // 不能固定值，横竖屏触发会重置
  bool get _isFullScreen =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  @override
  void initState() {
    super.initState();
    widget.opacityCallback = (appear) {
      _opacity = appear ? 1.0 : 0.0;
      if (!mounted) return;
      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 250),
        child: Container(
            width: double.maxFinite,
            height: 40,
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(0, 0, 0, .7),
                  Color.fromRGBO(0, 0, 0, 0)
                ],
              ),
            ),
            child: Row(
              children: [
                _isFullScreen
                    ? IconButton(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        onPressed: () => VideoPlayerUtils.setPortrait(), // 切换竖屏
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      )
                    : const SizedBox(
                        width: 15,
                      ),
                Text(
                  widget.title,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    if (kDebugMode) {
                      print("点击了：开发者可自行定义");
                    }
                  },
                  icon: const Icon(
                    Icons.more_horiz_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                )
              ],
            )),
      ),
    );
  }
}
