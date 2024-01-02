import 'dart:async';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:qianshi_music/models/album.dart';
import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/provider/album_provider.dart';
import 'package:qianshi_music/provider/comment_provider.dart';
import 'package:qianshi_music/provider/index_provider.dart';
import 'package:qianshi_music/provider/playlist_provider.dart';
import 'package:qianshi_music/provider/track_provider.dart';
import 'package:qianshi_music/stores/playing/track_store.dart';
import 'package:qianshi_music/utils/logger.dart';

class PlayingController extends GetxController {
  final _mPlayer = FlutterSoundPlayer(logLevel: Level.error);
  final RxBool isPlaying = RxBool(false);
  final Rx<Track?> _currentTrack = Rx(null);
  final RxDouble currentPosition = RxDouble(0);
  final RxDouble currentDuration = RxDouble(9999999);
  final tracks = <Track>[].obs;

  final Rx<BaseTrackStore?> trackStore = Rx<BaseTrackStore?>(null);

  final StreamController<String> _curPositionController =
      StreamController<String>.broadcast();

  Stream<String> get curPositionStream => _curPositionController.stream;
  Rx<Track?> get currentTrack => _currentTrack;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    await _mPlayer.openPlayer();
  }

  Future<(String?, Codec)> getTrackUrlAndType(Track track) async {
    final response = await SongProvider.url([track.id]);
    if (response.code != 200) {
      Get.snackbar('播放失败', response.msg ?? '未知错误');
      return (null, Codec.mp3);
    }
    var url = response.data.first.url;
    if (url == null) {
      Get.snackbar('播放失败', "该歌曲无法播放");
      return (null, Codec.mp3);
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

    return (url, codec);
  }

  Future<void> play({int? index}) async {
    if (trackStore.value == null) {
      return;
    }

    if (index != null) {
      trackStore.value!.currentTrackIndex = index;
      return;
    }

    final track = trackStore.value!.currentTrack;
    if (track == null) {
      return;
    }

    var (url, codec) = await getTrackUrlAndType(track);
    if (url == null) {
      return;
    }

    currentPosition.value = 0;
    final duration = await _mPlayer.startPlayer(
      fromURI: url,
      codec: codec,
      whenFinished: () {
        isPlaying.value = false;
        if (trackStore.value!.mode == PlayingMode.single) {
          play();
          return;
        }

        if (trackStore.value!.canNext) {
          trackStore.value!.next();
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

    return;

    // if (index != null && index < tracks.length) {
    //   if (index == _currentTrackIndex.value) {
    //     return;
    //   }
    //   _currentTrackIndex.value = index;
    // }

    // if (_currentTrackIndex.value == -1) {
    //   return;
    // }

    // final response = await SongProvider.url([currentTrack.value!.id]);
    // if (response.code != 200) {
    //   Get.snackbar('播放失败', response.msg ?? '未知错误');
    //   return;
    // }
    // var url = response.data.first.url;
    // if (url == null) {
    //   Get.snackbar('播放失败', "该歌曲无法播放");
    //   return;
    // }
    // if (url.startsWith("http:")) {
    //   url = url.replaceFirst("http:", "https:");
    // }
    // Codec codec = Codec.mp3;
    // switch (response.data.first.type) {
    //   case "flac":
    //     codec = Codec.flac;
    //     break;
    //   case "m4a":
    //     codec = Codec.aacADTS;
    //     break;
    //   case "wav":
    //     codec = Codec.pcm16WAV;
    //     break;
    //   default:
    //     break;
    // }
    // currentPosition.value = 0;
    // final duration = await _mPlayer.startPlayer(
    //   fromURI: url,
    //   codec: codec,
    //   whenFinished: () {
    //     if (_currentTrackIndex.value < tracks.length - 1) {
    //       _currentTrackIndex.value++;
    //       play();
    //     } else {
    //       isPlaying.value = false;
    //     }
    //   },
    // );
    // if (duration == null) {
    //   return;
    // }
    // currentDuration.value = duration.inMilliseconds.toDouble();
    // _mPlayer.setSubscriptionDuration(const Duration(milliseconds: 500));
    // _mPlayer.onProgress!.listen((event) {
    //   currentPosition.value = event.position.inMilliseconds.toDouble();
    //   _curPositionController.sink.add(
    //       "${event.position.inMilliseconds}-${event.duration.inMilliseconds}");
    // });
    // isPlaying.value = true;
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

  Future<void> addTracks(List<Track> tracks, {int? palyNowIndex}) async {
    stop();
    trackStore.value = TracksTrackStore(tracks, trackUpdated: trackUpdated);

    if (palyNowIndex != null) {
      trackStore.value!.currentTrackIndex = palyNowIndex;
      await play();
    }
  }

  Future<void> addTrack(Track track, {bool playNow = false}) async {
    trackStore.value ??= TracksTrackStore([track], trackUpdated: trackUpdated);

    if (!trackStore.value!.canAddToNext) {
      return;
    }

    trackStore.value!.addToNext(track);

    if (playNow) {
      final tracks = trackStore.value!.getTracks();
      final index = tracks.indexWhere((element) => element.id == track.id);
      trackStore.value!.currentTrackIndex = index;
      await play();
    }
  }

  Future<void> removeTrack(Track track) async {
    if (trackStore.value == null) return;
    final store = trackStore.value!;
    final tracks = store.getTracks();
    final index = tracks.indexWhere((element) => element.id == track.id);
    if (index == -1) return;
    store.remove(index);
  }

  trackUpdated(Track? track) async {
    _currentTrack.value = track;
    if (track == null) {
      stop();
      return;
    }
    bool isPlaying = this.isPlaying.value;
    await stop();
    if (isPlaying) {
      await play();
    }
  }

  Future<bool> playFm() async {
    if (trackStore.value == null ||
        trackStore.value!.source != PlayingSource.fm) {
      final isPlaying = this.isPlaying.value;
      if (isPlaying) stop();
      final response = await IndexProvider.personalFm();
      if (response.code != 200) {
        Get.snackbar('获取个人FM音乐失败', response.msg!);
        return false;
      }
      trackStore.value =
          FmTrackStore(response.data, trackUpdated: trackUpdated);
      if (isPlaying) await play();
      return true;
    }
    if (!isPlaying.value) {
      await play();
    }
    return true;
  }

  Future<bool> addAlbum(
    Album album, {
    bool playNow = true,
    int? playTrackId,
  }) async {
    if (trackStore.value != null &&
        trackStore.value!.source == PlayingSource.album) {
      final albumStore = trackStore.value as AlbumTrackStore;
      if (albumStore.album.id != album.id) {
        final response = await AlbumProvider.index(album.id);
        if (response.code != 200) {
          Get.snackbar('Error', response.msg!);
          return false;
        }
        trackStore.value =
            AlbumTrackStore(album, response.songs, trackUpdated: trackUpdated);
      }
    }

    final store = trackStore.value!;

    if (!playNow) {
      store.currentTrackIndex = -1;
      return true;
    }
    final playIndex = playTrackId == null
        ? 0
        : store.tracks.indexWhere((element) => element.id == playTrackId);

    if (playIndex == store.currentTrackIndex) {
      if (!isPlaying.value) {
        await resume();
      }
    } else {
      store.currentTrackIndex = playIndex;
      await play();
    }
    return true;
  }

  Future<bool> addPlaylist(
    Playlist playlist, {
    bool playNow = true,
    int? playTrackId,
  }) async {
    if (trackStore.value == null ||
        trackStore.value!.source != PlayingSource.playlist) {
      final response = await PlaylistProvider.trackAll(playlist.id, limit: 100);
      if (response.code != 200) {
        Get.snackbar('Error', response.msg!);
        return false;
      }
      trackStore.value = PlaylistTrackStore(playlist, response.songs,
          trackUpdated: trackUpdated);
    } else if (trackStore.value!.source == PlayingSource.playlist) {
      final playlistStore = trackStore.value as PlaylistTrackStore;
      if (playlistStore.playlist.id != playlist.id) {
        final response =
            await PlaylistProvider.trackAll(playlist.id, limit: 100);
        if (response.code != 200) {
          Get.snackbar('Error', response.msg!);
          return false;
        }
        trackStore.value = PlaylistTrackStore(playlist, response.songs,
            trackUpdated: trackUpdated);
      }
    }

    final store = trackStore.value!;

    if (!playNow) {
      store.currentTrackIndex = -1;
      return true;
    }

    final playIndex = playTrackId == null
        ? 0
        : store.tracks.indexWhere((element) => element.id == playTrackId);
    logger.i('playindex:$playIndex');
    if (playIndex == store.currentTrackIndex) {
      if (!isPlaying.value) {
        await resume();
      }
    } else {
      store.currentTrackIndex = playIndex;
      await play();
    }
    return true;
  }

  void nextPlay(Track track) {
    if (!(trackStore.value?.canAddToNext ?? false)) {
      return;
    }
    trackStore.value!.addToNext(track);
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
    if (!(trackStore.value?.canNext ?? false)) {
      return;
    }
    await trackStore.value!.next();
  }

  Future<void> prev() async {
    if (!(trackStore.value?.canPrevious ?? false)) {
      return;
    }
    await trackStore.value!.previous();
  }
}
