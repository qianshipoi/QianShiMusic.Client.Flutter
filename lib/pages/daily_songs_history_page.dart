import 'package:flutter/material.dart';
import 'package:qianshi_music/models/track.dart';

import 'package:qianshi_music/provider/history_provider.dart';
import 'package:qianshi_music/widgets/keep_alive_wrapper.dart';
import 'package:qianshi_music/widgets/tiles/track_tile.dart';

class DailySongsHistory extends StatefulWidget {
  const DailySongsHistory({super.key});

  @override
  State<DailySongsHistory> createState() => _DailySongsHistoryState();
}

class _DailySongsHistoryState extends State<DailySongsHistory>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      getHistoryDate();
    });
  }

  Future<List<String>> getHistoryDate() async {
    final response = await HistoryProvider.recommendSongs();
    if (response.code != 200) {
      throw Exception("获取日推历史失败");
    }

    _tabController =
        TabController(length: response.data!.dates.length, vsync: this);

    return response.data!.dates;
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getHistoryDate(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('获取日推历史失败'));
        }
        if (snapshot.hasData) {
          final dates = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text('历史日推'),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: TabBar(
                  controller: _tabController,
                  tabs: dates.map((e) => Tab(child: Text(e))).toList(),
                ),
              ),
            ),
            body: PageView(
              children: dates
                  .map(
                      (e) => KeepAliveWrapper(child: HistorySongsView(date: e)))
                  .toList(),
            ),
          );
        }

        return const Center(child: LinearProgressIndicator());
      },
    );
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
