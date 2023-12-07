import 'dart:async';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/widgets/video_player/video_player_utils.dart';

class VidepPlayerSilder extends StatefulWidget {
  const VidepPlayerSilder({super.key});

  @override
  State<VidepPlayerSilder> createState() => _VidepPlayerSilderState();
}

class _VidepPlayerSilderState extends State<VidepPlayerSilder> {
  double _sliderValue = 0.0;
  String _currentDuration = "00:00";
  ui.Image? _customImage; // 自定义thumbShape
  bool _onChanged = false; // 是否正在拖拽

  @override
  void initState() {
    // 注意，切换横竖屏后，刷新widget，需将播放进度设置为当前position，而不是0
    if (VideoPlayerUtils.isInitialized) {
      _sliderValue = VideoPlayerUtils.position.inMilliseconds /
          VideoPlayerUtils.duration.inMilliseconds;
    }
    super.initState();
    VideoPlayerUtils.positionListener(
        key: this,
        listener: (seconds) {
          if (_onChanged == true) return;
          _currentDuration = VideoPlayerUtils.formatDuration(seconds);
          _sliderValue = seconds / VideoPlayerUtils.duration.inSeconds;
          if (!mounted) return;
          setState(() {});
        });
    loadImage().then((image) {
      _customImage = image;
      if (!mounted) return;
      setState(() {});
    });
  }

  Future<ui.Image> loadImage() async {
    return loadImageByProvider(const CachedNetworkImageProvider(
        AssetsContants.defaultAvatar,
        maxHeight: 32,
        maxWidth: 32));
    // ByteData data = await rootBundle.load(AssetsContants.defaultAvatar);
    // ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    // ui.FrameInfo fi = await codec.getNextFrame();

    // return fi.image;
  }

  static Future<ui.Image> loadImageByProvider(
    ImageProvider provider, {
    ImageConfiguration config = ImageConfiguration.empty,
  }) async {
    Completer<ui.Image> completer = Completer<ui.Image>(); //完成的回调
    late ImageStreamListener listener;
    ImageStream stream = provider.resolve(config); //获取图片流
    listener = ImageStreamListener((ImageInfo frame, bool sync) {
      final ui.Image image = frame.image;
      completer.complete(image); //完成
      stream.removeListener(listener); //移除监听
    });
    stream.addListener(listener); //添加监听
    return completer.future; //返回
  }

  @override
  void dispose() {
    VideoPlayerUtils.removePositionListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _customImage == null
        ? const SizedBox()
        : Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 8,
                    inactiveTrackColor: Colors.grey,
                    activeTrackColor: Colors.greenAccent,
                    thumbShape: SliderThumbImage(image: _customImage),
                    trackShape: const CustomTrackShape(),
                  ),
                  child: Slider(
                    value: _sliderValue,
                    onChangeStart: (_) {
                      _onChanged = true;
                    },
                    onChangeEnd: (double value) {
                      _onChanged = false;
                      int millisecond =
                          (value * VideoPlayerUtils.duration.inMilliseconds)
                              .toInt();
                      VideoPlayerUtils.seekTo(
                          position: Duration(milliseconds: millisecond));
                    },
                    onChanged: (double value) {
                      int seconds =
                          (value * VideoPlayerUtils.duration.inSeconds).toInt();
                      _currentDuration =
                          VideoPlayerUtils.formatDuration(seconds);
                      _sliderValue = value;
                      if (!mounted) return;
                      setState(() {});
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                _currentDuration,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              )
            ],
          );
  }
}

class SliderThumbImage extends SliderComponentShape {
  const SliderThumbImage({Key? key, this.image});
  final ui.Image? image;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(0, 0);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final canvas = context.canvas;
    final imageWidth = image?.width ?? 10;
    final imageHeight = image?.height ?? 10;
    Offset imageOffset = Offset(
      center.dx - imageWidth * 0.5,
      center.dy - imageHeight * 0.5 - 2,
    );
    if (image != null) {
      canvas.drawImage(image!, imageOffset, Paint());
    }
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  const CustomTrackShape();
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackWidth = parentBox.size.width;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
