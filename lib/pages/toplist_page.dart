import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/models/toplist.dart';
import 'package:qianshi_music/pages/base_playing_state.dart';
import 'package:qianshi_music/pages/playlist_detail_page.dart';
import 'package:qianshi_music/provider/toplist_provider.dart';

class ToplistPage extends StatefulWidget {
  const ToplistPage({super.key});

  @override
  State<ToplistPage> createState() => _ToplistPageState();
}

class _ToplistPageState extends BasePlayingState<ToplistPage>
    with TickerProviderStateMixin {
  final List<Toplist> _toplists = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getToplists();
    });
  }

  Future _getToplists() async {
    final response = await ToplistProvider.detail();
    if (response.code == 200) {
      _toplists.clear();
      _toplists.addAll(response.list);
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
  String get heroTag => "toplist_page_playing_bar";

  @override
  Widget buildPageBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('排行榜'),
        centerTitle: true,
      ),
      body: _buildTabBarPageView(context),
    );
  }

  Widget _buildTabBarPageView(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.3),
      child: ListView.builder(
        itemCount: _toplists.length,
        itemBuilder: (context, index) {
          final toplist = _toplists[index];
          return ListTile(
            title: Text(toplist.name),
            subtitle: Text(
              toplist.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () {
              Get.to(() => PlaylistDetailPage(
                    playlistId: toplist.id,
                    heroTag: heroTag,
                  ));
            },
          );
        },
      ),
    );
  }
}
