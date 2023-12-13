import 'package:get/get.dart';
import 'package:qianshi_music/models/login_account.dart';
import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/models/user_profile.dart';
import 'package:qianshi_music/provider/playlist_provider.dart';
import 'package:qianshi_music/provider/user_provider.dart';

class CurrentUserController extends GetxController {
  final Rx<LoginAccount?> currentAccount = Rx<LoginAccount?>(null);
  final Rx<UserProfile?> currentProfile = Rx<UserProfile?>(null);

  final RxList<Playlist> userPlaylist = <Playlist>[].obs;
  final RxList<Track> userFavorite = <Track>[].obs;

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
    currentProfile.value = response.profile!;
  }

  Future<void> _loadMyPlaylist() async {
    final response = await UserProvider.playlist(currentAccount.value!.id);
    if (response.code != 200) {
      Get.snackbar('获取歌单失败', response.msg ?? '未知错误');
      return;
    }
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
}
