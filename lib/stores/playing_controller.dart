import 'dart:async';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/provider/track_provider.dart';
import 'package:qianshi_music/utils/logger.dart';

class PlayingController extends GetxController {
  bool _showLyric = false;
  bool get showLyric => _showLyric;
  set showLyric(bool value) {
    _showLyric = value;
    update();
  }

  final _mPlayer = FlutterSoundPlayer();
  final RxBool isPlaying = RxBool(false);
  final Rx<Track?> _currentTrack = Rx(null);
  final RxInt currentPosition = RxInt(0);

  final StreamController<String> _curPositionController =
      StreamController<String>.broadcast();

  Stream<String> get curPositionStream => _curPositionController.stream;
  Track? get currentTrack => _currentTrack.value;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    await _mPlayer.openPlayer();
  }

  Future<void> load(Track track) async {
    _currentTrack.value = track;
  }

  Future<void> play({Track? track}) async {
    if (track == null) {
      if (_currentTrack.value == null) {
        return;
      }
      track = _currentTrack.value;
    }
    _currentTrack.value = track;
    final response = await SongProvider.url(track!.id.toString());
    if (response.code != 200) {
      Get.snackbar('播放失败', response.msg ?? '未知错误');
      return;
    }
    var url = response.data!.first.url!;
    if (url.startsWith("http:")) {
      url = url.replaceFirst("http:", "https:");
    }
    Codec codec = Codec.mp3;
    switch (response.data!.first.type) {
      case "flac":
        codec = Codec.flac;
        break;
      case "m4a":
        codec = Codec.aacADTS;
        break;
      case "wav":
        codec = Codec.pcm16WAV;
        break;
      default:
        break;
    }
    logger.i(response.data!.first.url);
    await _mPlayer.startPlayer(
      fromURI: url,
      codec: codec,
      whenFinished: () {
        isPlaying.value = false;
      },
    );
    _mPlayer.setSubscriptionDuration(const Duration(milliseconds: 500));
    _mPlayer.onProgress!.listen((event) {
      currentPosition.value = event.position.inMilliseconds;
      _curPositionController.sink.add(
          "${event.position.inMilliseconds}-${event.duration.inMilliseconds}");
    });
    isPlaying.value = true;
  }

  Future<void> pause() async {
    if (!_mPlayer.isPlaying) return;
    await _mPlayer.pausePlayer();
    isPlaying.value = false;
  }

  Future<void> resume() async {
    if (_currentTrack.value == null) {
      return;
    }
    if (!_mPlayer.isPaused) {
      await play();
      return;
    }
    await _mPlayer.resumePlayer();
    isPlaying.value = true;
  }

  Future<void> stop() async {
    await _mPlayer.stopPlayer();
    isPlaying.value = false;
  }

  Future<void> seekTo(int millisecond) async {
    await _mPlayer.seekToPlayer(Duration(milliseconds: millisecond));
    if (!isPlaying.value) {
      play();
    }
  }
}
