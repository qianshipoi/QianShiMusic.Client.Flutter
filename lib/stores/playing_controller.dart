import 'dart:async';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:qianshi_music/models/album.dart';
import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/provider/album_provider.dart';
import 'package:qianshi_music/provider/playlist_provider.dart';
import 'package:qianshi_music/provider/track_provider.dart';

class PlayingController extends GetxController {
  final _mPlayer = FlutterSoundPlayer(logLevel: Level.error);
  final RxBool isPlaying = RxBool(false);
  final Rx<Track?> _currentTrack = Rx(null);
  final RxDouble currentPosition = RxDouble(0);
  final RxDouble currentDuration = RxDouble(9999999);
  final tracks = <Track>[].obs;
  final RxInt _currentTrackIndex = RxInt(-1);

  final StreamController<String> _curPositionController =
      StreamController<String>.broadcast();

  Stream<String> get curPositionStream => _curPositionController.stream;
  Rx<Track?> get currentTrack => _currentTrack;

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

  Future<void> play({int? index}) async {
    if (index != null && index < tracks.length) {
      if (index == _currentTrackIndex.value) {
        return;
      }
      _currentTrackIndex.value = index;
    }

    if (_currentTrackIndex.value == -1) {
      return;
    }

    final response = await SongProvider.url([currentTrack.value!.id]);
    if (response.code != 200) {
      Get.snackbar('播放失败', response.msg ?? '未知错误');
      return;
    }
    var url = response.data.first.url;
    if (url == null) {
      Get.snackbar('播放失败', "该歌曲无法播放");
      return;
    }
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
    currentPosition.value = 0;
    final duration = await _mPlayer.startPlayer(
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
    if (duration == null) {
      return;
    }
    currentDuration.value = duration.inMilliseconds.toDouble();
    _mPlayer.setSubscriptionDuration(const Duration(milliseconds: 500));
    _mPlayer.onProgress!.listen((event) {
      currentPosition.value = event.position.inMilliseconds.toDouble();
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
  int _albumId = 0;

  Future<bool> addAlbum(
    Album album, {
    bool playNow = true,
    int? playTrackId,
  }) async {
    if (_albumId != album.id) {
      final response = await AlbumProvider.index(album.id);
      if (response.code != 200) {
        Get.snackbar('Error', response.msg!);
        return false;
      }
      tracks.clear();
      tracks.addAll(response.songs);
      _albumId = album.id;
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

  void nextPlay(Track track) {
    final index = tracks.indexWhere((element) => element.id == track.id);
    if (index != -1) {
      // track exists
      if (_currentTrackIndex.value == index ||
          _currentTrackIndex.value == index + 1) return;
      if (index < _currentTrackIndex.value) {
        tracks.removeAt(index);
        _currentTrackIndex.value--;
      } else {
        tracks.removeAt(index);
      }
      tracks.insert(_currentTrackIndex.value + 1, track);
    }
    tracks.insert(_currentTrackIndex.value + 1, track);
  }

  Future<bool> nextPlayById(int trackId) async {
    final response = await SongProvider.detail([trackId]);
    if (response.code != 200) {
      Get.snackbar('Error', response.msg!);
      return false;
    }
    nextPlay(response.songs.first);
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
