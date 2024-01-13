import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/models/responses/record/record_recent_response.dart';
import 'package:qianshi_music/pages/video/mv_page.dart';
import 'package:qianshi_music/provider/mv_provider.dart';
import 'package:qianshi_music/provider/record_provider.dart';
import 'package:qianshi_music/widgets/tiles/mv_recent_tile.dart';
import 'package:qianshi_music/widgets/tiles/video_recent_tile.dart';

class HistoryVideos extends StatefulWidget {
  const HistoryVideos({super.key});

  @override
  State<HistoryVideos> createState() => _HistoryVideosState();
}

class _HistoryVideosState extends State<HistoryVideos> {
  final List<RecordRecent> _recordRecents = [];

  Future _onLoading() async {
    final response = await RecordProvider.recentVideo();
    if (response.code != 200) {
      Get.snackbar("获取历史视频失败", response.msg!);
      return;
    }
    _recordRecents.addAll(response.data!.list);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _onLoading();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _recordRecents.length,
      itemBuilder: (context, index) {
        final recet = _recordRecents[index];
        if (recet.resourceType == RecordRecent.mvType) {
          final recetMv = RecordRecentMv.fromMap(recet.data);
          return MvRecentTile(
            video: recetMv,
            onTap: () async {
              final response = await MvProvider.detail(recetMv.id);
              if (response.code != 200) {
                Get.snackbar('获取MV失败', response.msg!);
                return;
              }
              Get.to(() => MvPage(mv: response.data!));
            },
          );
        } else if (recet.resourceType == RecordRecent.mlogTyoe) {
          final recentVideo = RecordRecentMlog.fromMap(recet.data);
          return VideoRecentTile(video: recentVideo);
        }
        return const ListTile(title: Text("Not Impo"));
      },
    );
  }
}
