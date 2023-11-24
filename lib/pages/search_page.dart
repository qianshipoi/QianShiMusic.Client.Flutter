import 'package:flutter/material.dart';
import 'package:qianshi_music/widgets/cat_playlist.dart';
import 'package:qianshi_music/widgets/keep_alive_wrapper.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class SearchType {
  final String name;
  final int type;
  const SearchType(this.name, this.type);
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final List<SearchType> tabs = [
    const SearchType('综合', 1018),
    const SearchType('单曲', 1),
    const SearchType('歌手', 100),
    const SearchType('专辑', 10),
    const SearchType('视频', 1014),
    const SearchType('歌单', 1000),
    const SearchType('电台', 1009),
    const SearchType('用户', 1002),
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
      appBar: AppBar(
        title: const Text('搜索'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: _buildTabBar(),
        ),
      ),
      body: _buildTabBarPageView(),
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
      tabs: tabs.map<Tab>((e) => Tab(text: e.name)).toList(),
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
    return tabs
        .map<Widget>((e) => KeepAliveWrapper(child: CatPlaylist(cat: e.name)))
        .toList();
  }
}
