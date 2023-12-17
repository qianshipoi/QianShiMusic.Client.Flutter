import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/provider/playlist_provider.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class CatPlaylist extends StatefulWidget {
  final String cat;
  final void Function(int playlistId)? onTap;
  const CatPlaylist({
    Key? key,
    required this.cat,
    this.onTap,
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshController.requestLoading();
    });
  }

  _onRefresh() async {
    final response = await PlaylistProvider.top(cat: widget.cat);
    if (response.code == 200) {
      playlist.clear();
      playlist.addAll(response.playlists);
      more = response.more;
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
    final response = await PlaylistProvider.top(
        cat: widget.cat, limit: limit, offset: page * limit);
    if (response.code == 200) {
      playlist.addAll(response.playlists);
      more = response.more;
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
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap!(playlist[i].id);
            }
          },
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(12)),
                clipBehavior: Clip.antiAlias,
                child: Obx(
                  () => FixImage(
                    imageUrl: formatMusicImageUrl(playlist[i].coverImgUrl.value,
                        size: 200),
                  ),
                ),
              ),
              Obx(() => Text(
                    playlist[i].name.value,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
            ],
          ),
        ),
        itemCount: playlist.length,
      ),
    );
  }
}
