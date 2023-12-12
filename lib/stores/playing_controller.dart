import 'dart:async';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/provider/playlist_provider.dart';
import 'package:qianshi_music/provider/track_provider.dart';
import 'package:qianshi_music/utils/logger.dart';

class PlayingController extends GetxController {
  bool _showLyric = false;
  bool get showLyric => _showLyric;
  set showLyric(bool value) {
    _showLyric = value;
    update();
  }

  final _mPlayer = FlutterSoundPlayer(logLevel: Level.warning);
  final RxBool isPlaying = RxBool(false);
  final Rx<Track?> _currentTrack = Rx(null);
  final RxInt currentPosition = RxInt(0);
  final tracks = <Track>[].obs;
  final RxInt _currentTrackIndex = RxInt(-1);

  final StreamController<String> _curPositionController =
      StreamController<String>.broadcast();

  Stream<String> get curPositionStream => _curPositionController.stream;
  Track? get currentTrack => _currentTrack.value;

  @override
  void onInit() {
    super.onInit();
    init();
    ever(_currentTrackIndex, (callback) {
      _currentTrack.value = callback == -1 ? null : tracks[callback];
    });
  }

  Future<void> init() async {
    await _mPlayer.openPlayer();
  }

  Future<void> play() async {
    if (_currentTrackIndex.value == -1) {
      return;
    }

    final response = await SongProvider.url([currentTrack!.id]);
    if (response.code != 200) {
      Get.snackbar('播放失败', response.msg ?? '未知错误');
      return;
    }
    var url = response.data.first.url!;
    if (url.startsWith("http:")) {
      url = url.replaceFirst("http:", "https:");
    }
    Codec codec = Codec.mp3;
    switch (response.data.first.type) {
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
    logger.i(response.data.first.url);
    await _mPlayer.startPlayer(
      fromURI: url,
      codec: codec,
      whenFinished: () {
        if (_currentTrackIndex.value < tracks.length - 1) {
          _currentTrackIndex.value++;
          play();
        } else {
          isPlaying.value = false;
        }
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

  Future<void> addTrack(Track track, {bool playNow = false}) async {
    final trackExists = tracks.any((element) => element.id == track.id);
    if (trackExists) {
      final index = tracks.indexWhere((element) => element.id == track.id);
      if (index == _currentTrackIndex.value) {
        if (playNow && !isPlaying.value) {
          await resume();
        }
        return;
      }
      track = tracks[index];
      tracks.removeAt(index);
      if (index < _currentTrackIndex.value) {
        _currentTrackIndex.value--;
      }
    }
    tracks.insert(_currentTrackIndex.value + 1, track);
    if (playNow) {
      _currentTrackIndex.value++;
      await play();
    }
  }

  Future<void> removeTrack(Track track) async {
    final index = tracks.indexWhere((element) => element.id == track.id);
    tracks.removeAt(index);
    if (index <= _currentTrackIndex.value) {
      _currentTrackIndex.value--;
    }
  }

  int _playlistId = 0;

  Future<bool> addPlaylist(
    Playlist playlist, {
    bool playNow = true,
    int? playTrackId,
  }) async {
    if (_playlistId != playlist.id) {
      final response = await PlaylistProvider.trackAll(playlist.id);
      if (response.code != 200) {
        Get.snackbar('Error', response.msg!);
        return false;
      }
      tracks.clear();
      tracks.addAll(response.songs);
      _playlistId = playlist.id;
    }

    if (!playNow) {
      _currentTrackIndex.value = -1;
      return true;
    }

    final playIndex = playTrackId == null
        ? 0
        : tracks.indexWhere((element) => element.id == playTrackId);
    if (playIndex == _currentTrackIndex.value) {
      if (!isPlaying.value) {
        await resume();
      }
    } else {
      _currentTrackIndex.value = playIndex;
      await play();
    }
    return true;
  }

  Future<void> next() async {
    if (_currentTrackIndex.value < tracks.length - 1) {
      _currentTrackIndex.value++;
      await play();
    } else {
      isPlaying.value = false;
    }
  }

  Future<void> prev() async {
    if (_currentTrackIndex.value > 0) {
      _currentTrackIndex.value--;
      await play();
    } else {
      isPlaying.value = false;
    }
  }
}
