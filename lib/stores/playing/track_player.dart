import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:logger/logger.dart';

class TrackPlayer {
  TrackPlayer._internal();
  static TrackPlayer? _instance;
  static TrackPlayer getInstance() => _instance ??= TrackPlayer._internal();

  final _mPlayer = FlutterSoundPlayer(logLevel: Level.error);

  init() {
    _mPlayer.openPlayer();
  }
  

}
