import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/models/album.dart';
import 'package:qianshi_music/pages/album_page.dart';
import 'package:qianshi_music/provider/record_provider.dart';
import 'package:qianshi_music/widgets/tiles/album_tile.dart';

class HistoryAlbums extends StatefulWidget {
  const HistoryAlbums({super.key});

  @override
  State<HistoryAlbums> createState() => _HistoryAlbumsState();
}

class _HistoryAlbumsState extends State<HistoryAlbums> {
  final List<Album> _albums = [];

  Future _onLoading() async {
    final response = await RecordProvider.recentAlbum();
    if (response.code != 200) {
      Get.snackbar("获取历史专辑失败", response.msg!);
      return;
    }
    _albums.addAll(response.data!.list.map((e) => Album.fromMap(e.data)));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _onLoading();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _albums.length,
      itemBuilder: (context, index) {
        final album = _albums[index];
        return AlbumTile(
          album: album,
          onTap: () => Get.to(() => AlbumPage(album: album)),
        );
      },
    );
  }
}
