import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qianshi_music/models/responses/search_collect_response.dart';
import 'package:qianshi_music/models/video.dart';
import 'package:qianshi_music/provider/search_provider.dart';
import 'package:qianshi_music/widgets/tiles/video_tile.dart';

class SearchVideoView extends StatefulWidget {
  final String keyword;
  const SearchVideoView({
    Key? key,
    required this.keyword,
  }) : super(key: key);

  @override
  State<SearchVideoView> createState() => _SearchVideoViewState();
}

class _SearchVideoViewState extends State<SearchVideoView> {
  final List<Video> _items = [];
  final _refreshController = RefreshController(initialRefresh: false);
  bool more = true;
  int limit = 20;
  int page = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshController.requestLoading();
    });
  }

  Future _onLoading() async {
    if (!more) {
      _refreshController.loadNoData();
      return;
    }
    final response = await SearchProvider.search(
        widget.keyword, MusicSearchType.video,
        limit: limit, offset: (page - 1) * limit);
    final result = response as SearchVideoResponse;
    if (result.code != 200) {
      return;
    }

    _items.addAll(result.result!.videos);
    more = response.result!.hasMore;
    page++;
    _refreshController.loadComplete();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullUp: true,
      enablePullDown: false,
      controller: _refreshController,
      onLoading: _onLoading,
      child: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) =>
            VideoTile(video: _items[index], onTap: () {}),
      ),
    );
  }
}
