import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/pages/base_playing_state.dart';

import 'package:qianshi_music/pages/playlist_detail_page.dart';
import 'package:qianshi_music/provider/playlist_provider.dart';
import 'package:qianshi_music/widgets/cat_playlist.dart';
import 'package:qianshi_music/widgets/keep_alive_wrapper.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends BasePlayingState<PlaylistPage>
    with TickerProviderStateMixin {
  final List<String> tabs = [];
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
    getCatlist();
  }

  Future getCatlist() async {
    final response = await PlaylistProvider.catlist();
    if (response.code == 200) {
      tabs.clear();
      tabs.add(response.all!.name);
      tabs.addAll(response.sub.map((e) => e.name).toList());
      _controller = TabController(
          length: tabs.length, initialIndex: _controller.index, vsync: this);
      setState(() {});
    }
  }

  @override
  bool get show => false;

  @override
  Color get backgroundColor => Colors.grey.withOpacity(0.3);

  @override
  BorderRadius get borderRadius => const BorderRadius.only(
      topLeft: Radius.circular(16), topRight: Radius.circular(16));

  @override
  String get heroTag => "playlist_page_playing_bar";

  @override
  Widget buildPageBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('歌单列表'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: _buildTabBar(),
          ),
          Expanded(
            child: _buildTabBarPageView(),
          )
        ],
      ),
    );
  }

  TabBar _buildTabBar() {
    return TabBar(
      controller: _controller,
      isScrollable: true,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0xff2fcfbb), width: 3),
        insets: EdgeInsets.fromLTRB(0, 0, 0, 10),
      ),
      tabs: tabs.map<Tab>((e) => Tab(text: e)).toList(),
    );
  }

  Widget _buildTabBarPageView() {
    return Container(
      color: Colors.grey.withOpacity(0.3),
      child: TabBarView(
        controller: _controller,
        children: _buildItems(),
      ),
    );
  }

  List<Widget> _buildItems() {
    return tabs.map<Widget>((e) {
      return KeepAliveWrapper(
          child: CatPlaylist(
              cat: e,
              onTap: (playlistId) {
                Get.to(() => PlaylistDetailPage(
                      playlistId: playlistId,
                      heroTag: heroTag,
                    ));
              }));
    }).toList();
  }
}
