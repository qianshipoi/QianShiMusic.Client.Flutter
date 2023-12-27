import 'dart:async';

import 'package:get/get.dart';
import 'package:qianshi_music/models/album.dart';
import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/provider/index_provider.dart';

abstract class TrackStore {
  PlayingMode get mode;

  List<Track> getTracks();

  bool get canAddToNext;

  void addToNext(Track track);

  bool get canOrder;

  void order(PlayingMode mode);

  bool get canPrevious;

  FutureOr<Track?> previous();

  bool get canNext;

  FutureOr<Track?> next();
}

abstract class BaseTrackStore implements TrackStore {
  final List<Track> tracks;
  final List<Track> _internalTracks = [];
  int _currentTrackIndex = -1;
  final Function(Track?)? trackUpdated;

  @override
  PlayingMode mode = PlayingMode.order;

  BaseTrackStore(this.tracks, {this.trackUpdated}) {
    _internalTracks.addAll(tracks);
  }

  PlayingSource get source;

  @override
  List<Track> getTracks() => _internalTracks;

  Track? get currentTrack =>
      _currentTrackIndex == -1 ? null : _internalTracks[_currentTrackIndex];

  int get currentTrackIndex => _currentTrackIndex;

  /// 设置当前播放的歌曲 <br />
  /// 会通知trackUpdated
  set currentTrackIndex(int index) {
    if (index < -1 || index >= _internalTracks.length) return;
    _currentTrackIndex = index;
    _notifyTrackChanged();
  }

  @override
  bool get canAddToNext => true;

  @override
  bool get canOrder => true;

  @override
  void addToNext(Track track) {
    if (!canAddToNext) return;
    if (track.id == currentTrack?.id) return;
    // 判断当前歌曲是否在列表内
    final internalTrackIndex =
        _internalTracks.indexWhere((element) => element.id == track.id);

    final sourceTrackIndex =
        tracks.indexWhere((element) => element.id == track.id);

    if (internalTrackIndex != -1) {
      // 列表内存在歌曲
      if (_currentTrackIndex > internalTrackIndex) {
        // 歌曲在当前播放之前
        final track = _internalTracks.removeAt(internalTrackIndex);
        _currentTrackIndex--;
        _internalTracks.insert(_currentTrackIndex + 1, track);
      } else {
        // 歌曲在当前播放之后
        final track = _internalTracks.removeAt(internalTrackIndex);
        _internalTracks.insert(_currentTrackIndex + 1, track);
      }
    } else {
      // 列表内不存在歌曲
      _internalTracks.insert(_currentTrackIndex + 1, track);
    }

    final currentIndexBySource = currentTrack == null
        ? -1
        : tracks.indexWhere((element) => element.id == currentTrack!.id);

    if (sourceTrackIndex != -1) {
      if (currentIndexBySource == -1) {
        final track = tracks.removeAt(sourceTrackIndex);
        tracks.insert(0, track);
      } else {
        final track = tracks.removeAt(sourceTrackIndex);
        tracks.insert(currentIndexBySource + 1, track);
      }
    } else {
      tracks.insert(currentIndexBySource + 1, track);
    }
  }

  @override
  void order(PlayingMode mode) {
    if (!canOrder) return;
    if (this.mode == mode) return;

    Track? currentTrack;
    if (_currentTrackIndex != -1) {
      currentTrack = _internalTracks.removeAt(_currentTrackIndex);
    }
    if (mode == PlayingMode.random) {
      _internalTracks.shuffle();
      if (currentTrack != null) {
        _internalTracks.insert(0, currentTrack);
      }
    } else if (mode == PlayingMode.order) {
      _internalTracks.clear();
      _internalTracks.addAll(tracks);
    }
  }

  FutureOr<Track?> nextTrack() {
    if (_currentTrackIndex == _internalTracks.length - 1) {
      return null;
    } else {
      return _internalTracks[_currentTrackIndex + 1];
    }
  }

  FutureOr<Track?> previousTrack() {
    return (_currentTrackIndex == -1 || _currentTrackIndex == 0)
        ? null
        : _internalTracks[_currentTrackIndex - 1];
  }

  @override
  bool get canNext => _internalTracks.length > _currentTrackIndex + 1;

  @override
  FutureOr<Track?> next() {
    if (_currentTrackIndex == _internalTracks.length - 1) {
      return null;
    }
    _currentTrackIndex++;
    _notifyTrackChanged();
    return currentTrack;
  }

  @override
  bool get canPrevious => _currentTrackIndex > 0;

  @override
  FutureOr<Track?> previous() {
    if (_currentTrackIndex == -1 || _currentTrackIndex == 0) {
      return null;
    }
    _currentTrackIndex--;
    _notifyTrackChanged();
    return currentTrack;
  }

  void _notifyTrackChanged() {
    if (trackUpdated != null) {
      trackUpdated!(currentTrack);
    }
  }

  void remove(int index) {
    if (index < 0 || index > _internalTracks.length - 1) return;

    bool needUpdate = index == _currentTrackIndex;
    if (index < _currentTrackIndex) {
      _currentTrackIndex--;
    }

    final track = _internalTracks.removeAt(index);
    tracks.removeWhere((element) => element.id == track.id);
    if (needUpdate) {
      _notifyTrackChanged();
    }
  }

  void clear() {
    tracks.clear();
    _internalTracks.clear();
    _currentTrackIndex = -1;
    _notifyTrackChanged();
  }
}

class TracksTrackStore extends BaseTrackStore {
  TracksTrackStore(super.tracks, {super.trackUpdated});

  @override
  PlayingSource get source => PlayingSource.tracks;
}

class PlaylistTrackStore extends BaseTrackStore {
  final Playlist playlist;

  PlaylistTrackStore(this.playlist, super.tracks, {super.trackUpdated});

  @override
  PlayingSource get source => PlayingSource.playlist;
}

class FmTrackStore extends BaseTrackStore {
  FmTrackStore(super.tracks, {super.trackUpdated});

  @override
  bool get canAddToNext => false;

  @override
  bool get canOrder => false;

  @override
  bool get canNext => true;

  @override
  PlayingSource get source => PlayingSource.fm;

  @override
  FutureOr<Track?> nextTrack() async {
    if (_currentTrackIndex == _internalTracks.length - 1) {
      // 加载更多音乐
      final response = await IndexProvider.personalFm();
      if (response.code != 200) {
        Get.snackbar('获取FM失败', response.msg!);
        return null;
      }
      _internalTracks.addAll(response.data);
      tracks.addAll(response.data);
    }
    return super.nextTrack();
  }

  @override
  FutureOr<Track?> next() async {
    if (_currentTrackIndex == _internalTracks.length - 1) {
      // 加载更多音乐
      final response = await IndexProvider.personalFm();
      if (response.code != 200) {
        Get.snackbar('获取FM失败', response.msg!);
        return null;
      }
      _internalTracks.addAll(response.data);
      tracks.addAll(response.data);
    }
    return super.next();
  }
}

class AlbumTrackStore extends BaseTrackStore {
  final Album album;

  AlbumTrackStore(this.album, super.tracks, {super.trackUpdated});

  @override
  PlayingSource get source => PlayingSource.album;
}

enum PlayingMode { order, random, single }

enum PlayingSource { tracks, playlist, fm, album }
