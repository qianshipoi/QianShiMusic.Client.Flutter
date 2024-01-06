import 'package:flutter/material.dart';
import 'package:qianshi_music/pages/base_playing_state.dart';
import 'package:qianshi_music/pages/history/history_albums.dart';
import 'package:qianshi_music/pages/history/history_playlist.dart';
import 'package:qianshi_music/pages/history/history_songs.dart';
import 'package:qianshi_music/pages/history/history_video.dart';
import 'package:qianshi_music/widgets/keep_alive_wrapper.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends BasePlayingState<HistoryPage>
    with TickerProviderStateMixin {
  final List<String> tabs = ['歌曲', '视频', '歌单', '专辑'];
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget buildPageBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('历史播放'),
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
        children: const [
          KeepAliveWrapper(child: HistorySongs()),
          KeepAliveWrapper(child: HistoryVideos()),
          KeepAliveWrapper(child: HistoryPlaylist()),
          KeepAliveWrapper(child: HistoryAlbums()),
        ],
      ),
    );
  }
}
