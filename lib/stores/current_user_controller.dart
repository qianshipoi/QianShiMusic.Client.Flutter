import 'package:get/get.dart';
import 'package:qianshi_music/models/login_account.dart';
import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/models/user_profile.dart';
import 'package:qianshi_music/provider/playlist_provider.dart';
import 'package:qianshi_music/provider/user_provider.dart';
import 'package:qianshi_music/utils/logger.dart';

class CurrentUserController extends GetxController {
  final Rx<LoginAccount?> currentAccount = Rx<LoginAccount?>(null);
  final Rx<UserProfile?> currentProfile = Rx<UserProfile?>(null);

  final RxList<Playlist> userPlaylist = <Playlist>[].obs;
  final RxList<Track> userFavorite = <Track>[].obs;
  final RxList<Playlist> createdPlaylist = <Playlist>[].obs;
  final RxList<Playlist> favoritePlaylist = <Playlist>[].obs;
  final Rx<Playlist?> likedPlaylist = Rx<Playlist?>(null);

  @override
  void onInit() {
    super.onInit();
    ever(currentAccount, (callback) {
      if (callback == null) {
        currentProfile.value = null;
        userPlaylist.clear();
        userFavorite.clear();
      } else {
        _loadMyPlaylist();
        _loadProfile(callback.id);
      }
    });
  }

  Future<void> _loadProfile(int uid) async {
    final response = await UserProvider.detail(uid);
    if (response.code != 200) {
      Get.snackbar('获取用户信息失败', response.msg!);
      return;
    }
    currentProfile.value = response.profile;
  }

  refreshMyPlaylist() {
    _loadMyPlaylist();
    logger.i('refreshMyPlaylist');
  }

  Future<void> _loadMyPlaylist() async {
    final response =
        await UserProvider.playlist(currentAccount.value!.id, noCache: true);
    if (response.code != 200) {
      Get.snackbar('获取歌单失败', response.msg ?? '未知错误');
      return;
    }

    final playlists = response.playlist;
    if (playlists.isEmpty) {
      return;
    }
    createdPlaylist.clear();
    createdPlaylist.addAll(response.playlist.skip(1).where((element) =>
        element.creator != null &&
        element.creator!.userId == currentAccount.value!.id));
    favoritePlaylist.clear();
    favoritePlaylist.addAll(response.playlist.where((element) =>
        element.creator != null &&
        element.creator!.userId != currentAccount.value!.id));
    likedPlaylist.value = response.playlist.firstOrNull;

    userPlaylist.assignAll(response.playlist);
    await _loadMyLikeTracks();
  }

  Future<void> _loadMyLikeTracks() async {
    if (userPlaylist.isEmpty) {
      return;
    }
    final likePlaylist = userPlaylist[0];
    final response = await PlaylistProvider.trackAll(likePlaylist.id);
    if (response.code != 200) {
      Get.snackbar('获取喜欢的音乐失败', response.msg ?? '未知错误');
      return;
    }
    userFavorite.assignAll(response.songs);
  }

  bool isMyCreated(Playlist playlist) {
    return playlist.creator != null &&
        playlist.creator!.userId == currentAccount.value!.id;
  }

  bool isMyFavorite(Playlist playlist) {
    return favoritePlaylist.any((element) => playlist.id == element.id);
  }

  bool isMyLiked(Track track) {
    return userFavorite.any((element) => element.id == track.id);
  }
}
