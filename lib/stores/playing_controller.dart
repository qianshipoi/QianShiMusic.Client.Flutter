import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/provider/track_provider.dart';

class PlayingController extends GetxController {
  bool _showLyric = false;
  bool get showLyric => _showLyric;
  set showLyric(bool value) {
    _showLyric = value;
    update();
  }

  final _mPlayer = FlutterSoundPlayer();
  final RxBool _isPlaying = RxBool(false);
  final Rx<Track?> _currentTrack = Rx(null);
  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    await _mPlayer.openPlayer();
  }

  Future<void> play(Track track) async {
    _currentTrack.value = track;
    final response = await SongProvider.url(track.id.toString());
    if (response.code != 200) {
      Get.snackbar('播放失败', response.msg ?? '未知错误');
      return;
    }
    _mPlayer.startPlayer(
      fromURI: response.data!.url,
      codec: Codec.mp3,
      whenFinished: () {
        _isPlaying.value = false;
      },
    );
    _isPlaying.value = true;
  }

  Future<void> pause() async {
    await _mPlayer.pausePlayer();
    _isPlaying.value = false;
  }

  Future<void> resume() async {
    await _mPlayer.resumePlayer();
    _isPlaying.value = true;
  }

  Future<void> stop() async {
    await _mPlayer.stopPlayer();
    _isPlaying.value = false;
  }

  Future<void> seekTo(int millisecond) async {
    await _mPlayer.seekToPlayer(Duration(milliseconds: millisecond));
  }
}
