import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qianshi_music/models/artist.dart';
import 'package:qianshi_music/models/responses/artist_detail_response.dart';
import 'package:qianshi_music/pages/artist/artist_album.dart';
import 'package:qianshi_music/pages/artist/artist_dest.dart';
import 'package:qianshi_music/pages/artist/artist_hot_songs.dart';
import 'package:qianshi_music/pages/artist/artist_video.dart';
import 'package:qianshi_music/provider/artist_provider.dart';
import 'package:qianshi_music/widgets/fix_image.dart';
import 'package:qianshi_music/widgets/keep_alive_wrapper.dart';

class ArtistPage extends StatefulWidget {
  final Artist artist;
  const ArtistPage({
    Key? key,
    required this.artist,
  }) : super(key: key);

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  final _tabs = <String>['简介', '歌曲', '专辑', '视频'];
  ArtistDetailResponseData? data;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      _queryArtistDetail();
    });
  }

  Future<void> _queryArtistDetail() async {
    final response = await ArtistProvider.detail(widget.artist.id);
    if (response.code != 200) {
      Get.snackbar("获取歌手失败", response.msg!);
      return;
    }
    data = response.data!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return DefaultTabController(
      length: _tabs.length,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
                title: Text(data!.artist.name),
                centerTitle: false,
                pinned: true,
                floating: false,
                snap: false,
                primary: true,
                expandedHeight: 230.0,
                elevation: 10,
                forceElevated: innerBoxIsScrolled,
                actions: <Widget>[
                  IconButton(
                    selectedIcon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    icon: const Icon(Icons.favorite_outline),
                    isSelected: false,
                    onPressed: () {},
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: FixImage(
                    imageUrl: data!.artist.picUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
                bottom: TabBar(
                  tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          children: [
            KeepAliveWrapper(child: ArtistDest(artist: data!.artist)),
            KeepAliveWrapper(child: ArtistHotSongs(artist: data!.artist)),
            KeepAliveWrapper(child: ArtistAlbum(artist: data!.artist)),
            KeepAliveWrapper(child: ArtistVideo(artist: data!.artist)),
          ],
        ),
      ),
    );
  }
}
