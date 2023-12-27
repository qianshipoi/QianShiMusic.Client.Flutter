import 'package:flutter/material.dart';
import 'package:qianshi_music/models/album.dart';
import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/models/user_profile.dart';
import 'package:qianshi_music/provider/user_provider.dart';
import 'package:qianshi_music/widgets/card/album_card.dart';
import 'package:qianshi_music/widgets/card/playlist_card.dart';
import 'package:qianshi_music/widgets/fix_image.dart';
import 'package:qianshi_music/widgets/horizontal_title_list_view.dart';

class UserPage extends StatefulWidget {
  final int uid;
  const UserPage({
    super.key,
    required this.uid,
  });

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Future<UserProfile> _userTask;
  final List<Playlist> _playlists = [];
  final List<Album> _albums = [];

  Future<UserProfile> _getUserProfile() async {
    final response = await UserProvider.detail(widget.uid);
    if (response.code != 200) {
      throw Exception('Failed to load user profile');
    }

    // get user playlists
    final playlistResponse = await UserProvider.playlist(widget.uid);
    if (playlistResponse.code != 200) {
      throw Exception('Failed to load user playlists');
    }
    _playlists.addAll(playlistResponse.playlist);

    // // get user ablums
    // final albumResponse = await ArtistProvider.album(widget.uid);
    // if (albumResponse.code != 200) {
    //   throw Exception('Failed to load user albums');
    // }
    // _albums.addAll(albumResponse.hotAlbums);

    return response.profile!;
  }

  @override
  void initState() {
    super.initState();
    _userTask = _getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userTask,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final user = snapshot.data!;
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                _buildAppBar(user, context),
              ];
            },
            body: Column(children: [
              _buildProfile(user, context),
              _buildPlaylist(_playlists, context),
              _buildAlbums(_albums, context),
            ]),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  SliverAppBar _buildAppBar(UserProfile user, BuildContext context) {
    return SliverAppBar(
      pinned: true,
      title: Text(
        user.nickname,
        style: TextStyle(
            overflow: TextOverflow.ellipsis,
            color: Theme.of(context).colorScheme.onBackground),
      ),
      expandedHeight: 160.0,
      flexibleSpace: FlexibleSpaceBar(
        background: FixImage(
          imageUrl: user.backgroundUrl,
          fit: BoxFit.cover,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildProfile(UserProfile user, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.nickname,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        user.follows.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Text('关注'),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      Text(
                        user.followeds.toString(),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Text('粉丝'),
                    ],
                  ),
                ],
              )
            ],
          ),
          ElevatedButton(onPressed: () {}, child: const Text('关注')),
        ],
      ),
    );
  }

  Widget _buildPlaylist(List<Playlist> playlists, BuildContext context) {
    return HorizontalTitleListView(
      title: "Playlists",
      listView: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: PlaylistCard(playlist: playlist),
          );
        },
      ),
    );
  }

  Widget _buildAlbums(List<Album> albums, BuildContext context) {
    return HorizontalTitleListView(
      title: "Albums",
      listView: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: AlbumCard(album: album),
          );
        },
      ),
    );
  }
}
