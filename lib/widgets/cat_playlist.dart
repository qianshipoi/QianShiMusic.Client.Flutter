import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/pages/home/index_page.dart';
import 'package:qianshi_music/provider/playlist_provider.dart';
import 'package:qianshi_music/utils/logger.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class CatPlaylist extends StatefulWidget {
  final String cat;
  const CatPlaylist({
    Key? key,
    required this.cat,
  }) : super(key: key);

  @override
  State<CatPlaylist> createState() => _CatPlaylistState();
}

class _CatPlaylistState extends State<CatPlaylist> {
  final _refreshController = RefreshController(initialRefresh: false);
  final List<Playlist> playlist = <Playlist>[];
  bool more = true;
  int limit = 20;
  int page = 1;

  @override
  void initState() {
    super.initState();
    logger.i("initState:${widget.cat}");

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      logger.i("addPostFrameCallback:${timeStamp}");
      _refreshController.requestLoading();
    });
  }

  _onRefresh() async {
    final response = await PlaylistProvider.getPlaylistTop(cat: widget.cat);
    if (response.code == 200) {
      playlist.clear();
      playlist.addAll(response.playlists!);
      more = response.more!;
      page = 1;
      _refreshController.refreshCompleted();
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future _onLoading() async {
    if (!more) {
      _refreshController.loadNoData();
      return;
    }
    final response = await PlaylistProvider.getPlaylistTop(
        cat: widget.cat, limit: limit, offset: page * limit);
    if (response.code == 200) {
      playlist.addAll(response.playlists!);
      more = response.more!;
      page++;
      _refreshController.loadComplete();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullUp: true,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: GridView.builder(
        padding: const EdgeInsets.all(4.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          childAspectRatio: 0.7,
        ),
        physics: const ClampingScrollPhysics(),
        itemBuilder: (c, i) => GestureDetector(
          onTap: () => Get.toNamed(RouterContants.playlistDetail,
              arguments: playlist[i].id),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(12)),
                clipBehavior: Clip.antiAlias,
                child: FixImage(
                    imageUrl: formatMusicImageUrl(playlist[i].coverImgUrl,
                        size: 200)),
              ),
              Text(
                playlist[i].name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        itemCount: playlist.length,
      ),
    );
  }
}
