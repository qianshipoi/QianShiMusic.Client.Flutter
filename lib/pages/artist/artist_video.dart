import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:qianshi_music/models/artist.dart';
import 'package:qianshi_music/models/mv.dart';
import 'package:qianshi_music/pages/video/mv_page.dart';
import 'package:qianshi_music/provider/artist_provider.dart';
import 'package:qianshi_music/widgets/tiles/mv_title.dart';

class ArtistVideo extends StatefulWidget {
  final Artist artist;
  const ArtistVideo({
    Key? key,
    required this.artist,
  }) : super(key: key);

  @override
  State<ArtistVideo> createState() => _ArtistVideoState();
}

class _ArtistVideoState extends State<ArtistVideo> {
  final _refreshController = RefreshController(initialRefresh: false);
  final _mvs = <Mv>[];
  bool _more = true;
  int _offset = 0;
  final _limit = 20;

  Future _onLoading() async {
    if (!_more) {
      _refreshController.loadNoData();
      return;
    }
    try {
      final response = await ArtistProvider.mv(widget.artist.id,
          offset: _offset, limit: _limit);
      if (response.code != 200) {
        Get.snackbar("获取歌手专辑失败", response.msg!);
        return;
      }
      _mvs.addAll(response.mvs);
      _offset = _mvs.length;
      _more = response.hasMore;
      _refreshController.loadComplete();
      setState(() {});
    } finally {
      if (!_more) {
        _refreshController.loadNoData();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      _onLoading();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildTrackListView();
  }

  SmartRefresher _buildTrackListView() {
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      enablePullDown: false,
      onLoading: _onLoading,
      child: ListView.builder(
        itemCount: _mvs.length,
        itemBuilder: (context, index) {
          final mv = _mvs[index];
          return MvTile(
            video: mv,
            onTap: () {
              Get.to(() => MvPage(mv: mv));
            },
          );
        },
      ),
    );
  }
}
