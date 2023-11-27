import 'package:flutter/material.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/models/track.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class PlayPage extends StatefulWidget {
  final Track track;

  const PlayPage({super.key, required this.track});

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  bool _showLyric = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.track.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => setState(() => _showLyric = !_showLyric),
        child: Stack(children: [
          _showLyric ? _buildLyricView(context) : _buildMainView(context),
        ]),
      ),
    );
  }

  Widget _buildMainView(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.5),
            Colors.black,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          _buildImageView(context),
          _buildCenterView(context),
          _buildBottomView(context),
        ],
      ),
    );
  }

  Widget _buildLyricView(BuildContext context) {
    return Container();
  }

  Widget _buildImageView(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: ClipOval(
            child: Opacity(
              opacity: 0.5,
              child: Container(
                height: 100,
                width: 360,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        Center(
          child: ClipOval(
            child: Opacity(
              opacity: 0.7,
              child: Container(
                height: 200,
                width: 320,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(150),
            child: FixImage(
              imageUrl:
                  formatMusicImageUrl(widget.track.album.picUrl!, size: 400),
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(child: _buildPlayButton(context))
      ],
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(Icons.play_arrow),
        onPressed: () {},
      ),
    );
  }

  Widget _buildCenterView(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Text(
            widget.track.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            widget.track.artists.map((e) => e.name).join("/"),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Center(
              child: Slider(
            value: 0.5,
            onChanged: (value) {},
          )),
          const Row(
            children: [
              Text(
                "00:00",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Divider(height: 4, thickness: 1, color: Colors.white),
              Text(
                "00:00",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomView(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
