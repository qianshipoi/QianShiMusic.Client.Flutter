import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qianshi_music/models/album.dart';

import 'package:qianshi_music/models/artist.dart';
import 'package:qianshi_music/pages/album_page.dart';
import 'package:qianshi_music/provider/artist_provider.dart';
import 'package:qianshi_music/widgets/tiles/album_tile.dart';

class ArtistAlbum extends StatefulWidget {
  final Artist artist;
  const ArtistAlbum({
    Key? key,
    required this.artist,
  }) : super(key: key);

  @override
  State<ArtistAlbum> createState() => _ArtistAlbumState();
}

class _ArtistAlbumState extends State<ArtistAlbum> {
  final _refreshController = RefreshController(initialRefresh: false);
  final _albums = <Album>[];
  bool _more = true;
  int _offset = 0;
  final _limit = 20;
  bool _loading = true;

  Future _onLoading() async {
    if (!_more) {
      _refreshController.loadNoData();
      return;
    }
    try {
      final response = await ArtistProvider.album(widget.artist.id,
          offset: _offset, limit: _limit);
      if (response.code != 200) {
        Get.snackbar("获取歌手专辑失败", response.msg!);
        return;
      }
      _albums.addAll(response.hotAlbums);
      _offset = _albums.length;
      _more = response.more;
      _refreshController.loadComplete();
      setState(() {});
    } finally {
      _loading = false;
      setState(() {});
      if (!_more) {
        _refreshController.loadNoData();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      _onLoading();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return _buildTrackListView();
  }

  SmartRefresher _buildTrackListView() {
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      enablePullDown: false,
      onLoading: _onLoading,
      child: ListView.builder(
        itemCount: _albums.length,
        itemBuilder: (context, index) {
          final album = _albums[index];
          return AlbumTile(
            album: album,
            onTap: () {
              Get.to(() => AlbumPage(album: album));
            },
          );
        },
      ),
    );
  }
}
