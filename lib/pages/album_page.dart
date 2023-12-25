import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/constants.dart';

import 'package:qianshi_music/models/album.dart';
import 'package:qianshi_music/models/responses/album_response.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/pages/play_song/play_song_page.dart';
import 'package:qianshi_music/provider/album_provider.dart';
import 'package:qianshi_music/stores/playing_controller.dart';
import 'package:qianshi_music/widgets/fix_image.dart';
import 'package:qianshi_music/widgets/tiles/track_tile.dart';

class AlbumPage extends StatefulWidget {
  final Album album;
  const AlbumPage({
    Key? key,
    required this.album,
  }) : super(key: key);

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  final PlayingController _playingController = Get.find();
  late Future<AlbumResponse> _future;
  final List<Track> _tracks = [];

  @override
  void initState() {
    super.initState();
    _future = AlbumProvider.index(widget.album.id);
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            pinned: true,
            title: Text(
              widget.album.name,
              style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Theme.of(context).colorScheme.onBackground),
            ),
            expandedHeight: 230.0,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildProfile(widget.album),
            ),
          ),
        ];
      },
      body: FutureBuilder<AlbumResponse>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.hasData) {
            final response = snapshot.data!;
            if (response.code != 200) {
              return Center(child: Text(response.msg!));
            }

            final songs = snapshot.data!.songs;
            _tracks.clear();
            _tracks.addAll(songs);
            return ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return TrackTile(
                  index: index,
                  track: songs[index],
                  onTap: () {},
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildProfile(Album album) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: FixImage(
              imageUrl: album.picUrl!,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.0),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          album.artists.map((e) => e.name).join('/'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      _playingController.addAlbum(album, playTrackId: _tracks.firstOrNull?.id);
                      Get.to(() => PlaySongPage.instance);
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("播放全部"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
