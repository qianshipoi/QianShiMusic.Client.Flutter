import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qianshi_music/models/artist.dart';
import 'package:qianshi_music/models/responses/search_collect_response.dart';
import 'package:qianshi_music/provider/search_provider.dart';
import 'package:qianshi_music/utils/logger.dart';
import 'package:qianshi_music/widgets/tiles/search_artist_tile.dart';

class SearchArtistView extends StatefulWidget {
  final String keyword;
  const SearchArtistView({
    Key? key,
    required this.keyword,
  }) : super(key: key);

  @override
  State<SearchArtistView> createState() => _SearchArtistViewState();
}

class _SearchArtistViewState extends State<SearchArtistView> {
  final List<Artist> _items = [];
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
        widget.keyword, MusicSearchType.artist,
        limit: limit, offset: (page - 1) * limit);
    final result = response as SearchArtistResponse;
    if (result.code != 200) {
      return;
    }

    _items.addAll(result.result!.artists);
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
        itemExtent: 72,
        itemBuilder: (context, index) =>
            SearchArtistTile(artist: _items[index]),
      ),
    );
  }
}
