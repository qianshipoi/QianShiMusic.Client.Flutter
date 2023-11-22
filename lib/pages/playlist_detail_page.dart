import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/pages/home/index_page.dart';
import 'package:qianshi_music/utils/http/http_util.dart';
import 'package:qianshi_music/utils/logger.dart';
import 'package:qianshi_music/utils/ssj_request_manager.dart';

class PlaylistDetailPage extends StatefulWidget {
  const PlaylistDetailPage({super.key});

  @override
  State<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  final int playlistId = Get.arguments;

  Future<Playlist> getPlaylistDetail() async {
    final response = await HttpUtils.get('playlist/detail?id=$playlistId');
    final playlist = Playlist.fromMap(response.data['playlist']);
    return playlist;
  }

  @override
  void initState() {
    super.initState();
    getPlaylistDetail();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPlaylistDetail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final playlist = snapshot.data as Playlist;
          logger.i(playlist.tracks.length);
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 230.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    playlist.name,
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                  background: CachedNetworkImage(
                    httpHeaders: Map<String, String>.from(
                        {"User-Agent": bytesUserAgent}),
                    imageUrl: playlist.coverImgUrl,
                    fit: BoxFit.fitWidth,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              SliverFixedExtentList(
                  itemExtent: 40,
                  delegate: SliverChildListDelegate(
                    [
                      Text(playlist.description),
                      Text(playlist.playCount.toString()),
                    ],
                  )),
              SliverList(
                delegate: SliverChildBuilderDelegate((content, index) {
                  final track = playlist.tracks[index];
                  return ListTile(
                    title: Text(track.name),
                    subtitle: Text(track.al.name),
                    onTap: () {
                      logger.i(track.name);
                    },
                  );
                }, childCount: playlist.tracks.length),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
