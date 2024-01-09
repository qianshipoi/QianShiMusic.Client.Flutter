import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/models/artist.dart';
import 'package:qianshi_music/models/responses/artist_desc_response.dart';
import 'package:qianshi_music/provider/artist_provider.dart';

class ArtistDest extends StatefulWidget {
  final Artist artist;
  const ArtistDest({
    Key? key,
    required this.artist,
  }) : super(key: key);

  @override
  State<ArtistDest> createState() => _ArtistDestState();
}

class _ArtistDestState extends State<ArtistDest> {
  final List<Introduction> _introductions = [];
  late String _briefDesc;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      _queryArtistDetail();
    });
  }

  Future<void> _queryArtistDetail() async {
    final response = await ArtistProvider.desc(widget.artist.id);
    if (response.code != 200) {
      Get.snackbar("获取歌手简介失败", response.msg!);
      return;
    }
    _introductions.addAll(response.introduction);
    _briefDesc = response.briefDesc;
    _loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            '简介: $_briefDesc',
            style: const TextStyle(fontSize: 20),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _introductions.length,
            itemBuilder: (context, index) {
              final introduction = _introductions[index];
              return Column(
                children: [
                  Text(
                    introduction.ti,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    introduction.txt,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
