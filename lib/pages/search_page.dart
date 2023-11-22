import 'package:flutter/material.dart';
import 'package:qianshi_music/provider/playlist_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final List<String> tabs = ['单曲', '歌手', '专辑', '视频', '歌单', '电台', '用户'];
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
    getCatlist();
  }

  Future getCatlist() async {
    final response = await PlaylistProvider.getPlaylistCatlist();
    if (response.code == 200) {
      tabs.clear();
      tabs.add(response.all!.name);
      tabs.addAll(response.sub!.map((e) => e.name).toList());
      _controller = TabController(
          length: tabs.length, initialIndex: _controller.index, vsync: this);
      setState(() {});
    }
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
      floatingActionButton: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            tabs.add("新标签");
            _controller = TabController(
                length: tabs.length,
                initialIndex: _controller.index,
                vsync: this);
            setState(() {});
          }),
      body: TabBarView(
        controller: _controller,
        children: _buildItems(),
      ),
    );
  }

  _buildTabBar() {
    return TabBar(
      controller: _controller,
      isScrollable: true,
      labelColor: Colors.black,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0xff2fcfbb), width: 3),
        insets: EdgeInsets.fromLTRB(0, 0, 0, 10),
      ),
      tabs: tabs.map<Tab>((e) {
        return Tab(text: e);
      }).toList(),
    );
  }

  _buildTabBarPageView() {
    return KeepAlive(
      keepAlive: true,
      child: Expanded(
        flex: 1,
        child: Container(
          color: Colors.grey.withOpacity(0.3),
          child: TabBarView(
            controller: _controller,
            children: _buildItems(),
          ),
        ),
      ),
    );
  }

  _buildItems() {
    return tabs.map<Widget>((e) {
      return Container(
        child: Center(
          child: Text(e),
        ),
      );
    }).toList();
  }
}
