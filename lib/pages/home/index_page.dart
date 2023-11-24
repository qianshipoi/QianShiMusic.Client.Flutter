import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/utils/http/http_util.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List<Playlist> _playlists = [];

  Future<void> loadData() async {
    final response = await HttpUtils.get('top/playlist/highquality');
    final result = response.data as Map<String, dynamic>;

    if (result['code'] == 200) {
      final List<dynamic> playlists = result['playlists'] as List<dynamic>;
      _playlists = playlists
          .map((e) => Playlist.fromMap(e as Map<String, dynamic>))
          .toList();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _playlists.length,
      itemBuilder: (context, index) {
        final playlist = _playlists[index];
        return ListTile(
          leading: FixImage(
            imageUrl: "${playlist.coverImgUrl}?param=48y48",
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
          ),
          title: Text(
            playlist.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            playlist.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(formatPlayCount(playlist.playCount)),
          onTap: () {
            Get.toNamed(RouterContants.playlistDetail, arguments: playlist.id);
          },
        );
      },
    );
  }

  String formatPlayCount(int playcount) {
    if (playcount > 10000) {
      return "${(playcount / 10000).toStringAsFixed(1)}万";
    }
    return playcount.toString();
  }
}
