import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/models/album.dart';
import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/models/user_profile.dart';
import 'package:qianshi_music/pages/playlist_detail_page.dart';
import 'package:qianshi_music/provider/user_provider.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

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
    return SizedBox(
      height: 260,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Playlists'),
                TextButton(onPressed: () {}, child: const Text('See All')),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                final playlist = playlists[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: SizedBox(
                    width: 160,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(
                            () => PlaylistDetailPage(playlistId: playlist.id));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                            child: FixImage(
                              imageUrl: formatMusicImageUrl(
                                  playlist.coverImgUrl.value,
                                  size: 160),
                              width: 160,
                              height: 160,
                            ),
                          ),
                          Text(
                            playlist.name.value,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbums(List<Album> albums, BuildContext context) {
    return SizedBox(
      height: 260,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Albums'),
              TextButton(onPressed: () {}, child: const Text('See All')),
            ],
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: albums.length,
              itemBuilder: (context, index) {
                final album = albums[index];
                return SizedBox(
                  width: 200,
                  height: 200,
                  child: Column(
                    children: [
                      FixImage(
                        imageUrl: formatMusicImageUrl(album.picUrl, size: 200),
                        width: 200,
                        height: 200,
                      ),
                      Text(
                        album.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
