import 'dart:async';

import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/models/track.dart';

abstract class TrackStore {
  PlayingMode get mode;

  List<Track> getTracks();

  bool get canAddToNext;

  void addToNext(Track track);

  bool get canOrder;

  void order(PlayingMode mode);

  FutureOr<Track?> previous();

  FutureOr<Track?> next();
}

class PlaylistTrackStore implements TrackStore {
  final Playlist playlist;
  final List<Track> tracks;
  final List<Track> _internalTracks = [];
  int _currentTrackIndex = -1;

  @override
  PlayingMode mode = PlayingMode.order;

  PlaylistTrackStore(this.playlist, this.tracks) {
    _internalTracks.addAll(tracks);
  }

  @override
  List<Track> getTracks() => _internalTracks;

  Track? get currentTrack =>
      _currentTrackIndex == -1 ? null : _internalTracks[_currentTrackIndex];

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

  Track? nextTrack() {
    if (_currentTrackIndex == _internalTracks.length - 1) {
      return null;
    } else {
      return _internalTracks[_currentTrackIndex + 1];
    }
  }

  Track? previousTrack() {
    return (_currentTrackIndex == -1 || _currentTrackIndex == 0)
        ? null
        : _internalTracks[_currentTrackIndex - 1];
  }

  @override
  FutureOr<Track?> next() {
    if (_currentTrackIndex == _internalTracks.length - 1) {
      return null;
    }
    _currentTrackIndex++;
    return _internalTracks[_currentTrackIndex];
  }

  @override
  FutureOr<Track?> previous() {
    if (_currentTrackIndex == -1 || _currentTrackIndex == 0) {
      return null;
    }
    _currentTrackIndex--;
    return _internalTracks[_currentTrackIndex];
  }
}

enum TrackStoreType { playlist, album, artist, search, favorite }

enum PlayingMode { order, random, single }
