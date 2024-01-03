import 'package:flutter/material.dart';
import 'package:qianshi_music/models/track.dart';

import 'package:qianshi_music/provider/history_provider.dart';
import 'package:qianshi_music/widgets/keep_alive_wrapper.dart';
import 'package:qianshi_music/widgets/tiles/track_tile.dart';
import 'package:qianshi_music/pages/base_playing_state.dart';

class DailySongsHistory extends StatefulWidget {
  const DailySongsHistory({super.key});

  @override
  State<DailySongsHistory> createState() => _DailySongsHistoryState();
}

class _DailySongsHistoryState extends BasePlayingState<DailySongsHistory>
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
    final response = await HistoryProvider.recommendSongs();
    if (response.code == 200) {
      tabs.clear();
      tabs.addAll(response.data!.dates);
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
  String get heroTag => "daliy_songs_history_page_playing_bar";

  @override
  Widget buildPageBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('历史日推'),
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
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0xff2fcfbb), width: 3),
        insets: EdgeInsets.fromLTRB(0, 0, 0, 10),
      ),
      tabs: tabs.map<Tab>((e) => Tab(text: _formatDate(e))).toList(),
    );
  }

  Widget _buildTabBarPageView() {
    return Container(
      color: Colors.grey.withOpacity(0.2),
      child: TabBarView(
        controller: _controller,
        children: _buildItems(),
      ),
    );
  }

  List<Widget> _buildItems() {
    return tabs.map<Widget>((e) {
      return KeepAliveWrapper(
          child: HistorySongsView(
        date: e,
      ));
    }).toList();
  }

  String _formatDate(String date) {
    return date.substring(5);
  }
}

class HistorySongsView extends StatefulWidget {
  final String date;

  const HistorySongsView({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  State<HistorySongsView> createState() => _HistorySongsViewState();
}

class _HistorySongsViewState extends State<HistorySongsView> {
  Future<List<Track>> getTracks() async {
    final response = await HistoryProvider.recommendSongsDetail(widget.date);
    if (response.code != 200) {
      throw Exception(response.msg);
    }
    return response.data!.songs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTracks(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('获取日推历史失败'));
        }
        if (snapshot.hasData) {
          final tracks = snapshot.data!;
          return ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              final track = tracks[index];
              return TrackTile(track: track);
            },
          );
        }
        return const Center(child: LinearProgressIndicator());
      },
    );
  }
}
