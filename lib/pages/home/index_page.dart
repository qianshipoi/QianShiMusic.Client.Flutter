import 'package:flutter/material.dart';

import 'package:qianshi_music/pages/home/index/recommend_playlists.dart';
import 'package:qianshi_music/pages/home/index/recommend_songs.dart';
import 'package:qianshi_music/pages/home/index/regular_entry.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(children: [
        RegularEnter(),
        RecommendPlaylists(),
        RecommendSongs(),
      ]),
    );
  }
}
