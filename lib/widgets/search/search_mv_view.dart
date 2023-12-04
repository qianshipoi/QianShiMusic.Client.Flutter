import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qianshi_music/models/mv.dart';
import 'package:qianshi_music/models/responses/search_collect_response.dart';
import 'package:qianshi_music/provider/search_provider.dart';
import 'package:qianshi_music/widgets/tiles/mv_title.dart';

class SearchMvView extends StatefulWidget {
  final String keyword;
  const SearchMvView({
    Key? key,
    required this.keyword,
  }) : super(key: key);

  @override
  State<SearchMvView> createState() => _SearchMvViewState();
}

class _SearchMvViewState extends State<SearchMvView> {
  final List<Mv> _items = [];
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
        widget.keyword, MusicSearchType.playlist,
        limit: limit, offset: page * limit);
    final result = response as SearchMvResponse;
    if (result.code != 200) {
      return;
    }

    _items.addAll(result.result!.mvs);
    more = _items.length < result.result!.mvCount;
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
        itemBuilder: (context, index) => MvTile(video: _items[index]),
      ),
    );
  }
}
