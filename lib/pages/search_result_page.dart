import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/provider/search_provider.dart';
import 'package:qianshi_music/widgets/app_bar_search.dart';
import 'package:qianshi_music/widgets/keep_alive_wrapper.dart';
import 'package:qianshi_music/widgets/search_collect_view.dart';
import 'package:qianshi_music/widgets/search_playlist_view.dart';
import 'package:qianshi_music/widgets/search_song_view.dart';

class SearchResultPage extends StatefulWidget {
  final String keyword;
  const SearchResultPage({Key? key, required this.keyword}) : super(key: key);

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _ResultTab {
  final String name;
  final MusicSearchType type;
  const _ResultTab(this.name, this.type);
}

class _SearchResultPageState extends State<SearchResultPage>
    with TickerProviderStateMixin {
  final List<_ResultTab> tabs = [
    const _ResultTab("综合", MusicSearchType.collect),
    const _ResultTab("歌曲", MusicSearchType.song),
    const _ResultTab("歌单", MusicSearchType.playlist),
  ];
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarSearch(
          value: widget.keyword,
          onCancel: Get.back,
          onTap: Get.back,
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
        ));
  }

  _buildTabBar() {
    return TabBar(
      controller: _controller,
      isScrollable: true,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0xff2fcfbb), width: 3),
        insets: EdgeInsets.fromLTRB(0, 0, 0, 10),
      ),
      tabs: tabs.map<Tab>((e) => Tab(text: e.name)).toList(),
    );
  }

  _buildTabBarPageView() {
    return TabBarView(
      controller: _controller,
      children: _buildItems(),
    );
  }

  List<Widget> _buildItems() {
    return tabs.map<Widget>((e) {
      switch (e.type) {
        case MusicSearchType.collect:
          return KeepAliveWrapper(
              child: SearchCollectView(
            keyword: widget.keyword,
          ));
        case MusicSearchType.song:
          return KeepAliveWrapper(
              child: SearchSongView(
            keyword: widget.keyword,
          ));
        case MusicSearchType.playlist:
          return KeepAliveWrapper(
              child: SearchPlaylistView(
            keyword: widget.keyword,
          ));
        default:
          return const SizedBox();
      }
    }).toList();
  }
}
