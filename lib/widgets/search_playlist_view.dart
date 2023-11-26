import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qianshi_music/models/playlist.dart';
import 'package:qianshi_music/models/responses/search_collect_response.dart';
import 'package:qianshi_music/provider/search_provider.dart';
import 'package:qianshi_music/widgets/playlist_tile.dart';

class SearchPlaylistView extends StatefulWidget {
  final String keyword;
  const SearchPlaylistView({
    Key? key,
    required this.keyword,
  }) : super(key: key);

  @override
  State<SearchPlaylistView> createState() => _SearchPlaylistViewState();
}

class _SearchPlaylistViewState extends State<SearchPlaylistView> {
  final List<Playlist> _playlsist = [];
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
    final result = response as SearchPlaylistResponse;
    if (result.code != 200) {
      return;
    }

    _playlsist.addAll(result.result!.playlists);
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
        itemCount: _playlsist.length,
        itemBuilder: (context, index) =>
            PlaylistTile(playlist: _playlsist[index]),
      ),
    );
  }
}
