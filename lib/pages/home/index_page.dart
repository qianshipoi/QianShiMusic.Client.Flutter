import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/utils/http/http_util.dart';
import 'package:qianshi_music/utils/ssj_request_manager.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class Track {
  final int id;
  final String name;
  final Album al;

  Track(this.id, this.name, this.al);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'al': al.toMap(),
    };
  }

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      map['id'] as int,
      map['name'] as String,
      Album.fromMap(map['al'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Track.fromJson(String source) =>
      Track.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Album {
  final int id;
  final String name;
  final String picUrl;

  Album(this.id, this.name, this.picUrl);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'picUrl': picUrl,
    };
  }

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      map['id'] as int,
      map['name'] as String,
      map['picUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Album.fromJson(String source) =>
      Album.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Playlist {
  final int id;
  final String name;
  final String coverImgUrl;
  final String description;
  final int playCount;
  final List<Track> tracks;
  Playlist({
    required this.id,
    required this.name,
    required this.coverImgUrl,
    required this.description,
    required this.playCount,
    required this.tracks,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'coverImgUrl': coverImgUrl,
      'description': description,
      'playCount': playCount,
      'tracks': tracks.map((x) => x.toMap()).toList(),
    };
  }

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'] as int,
      name: map['name'] as String,
      coverImgUrl: map['coverImgUrl'] as String,
      description: map['description'] as String,
      playCount: map['playCount'] as int,
      tracks: (map.containsKey('tracks') && map['tracks'] != null)
          ? List<Map<String, dynamic>>.from(map['tracks'])
              .map((e) => Track.fromMap(e))
              .toList()
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Playlist.fromJson(String source) =>
      Playlist.fromMap(json.decode(source) as Map<String, dynamic>);
}

class _IndexPageState extends State<IndexPage> {
  List<Playlist> _playlists = [];

  Future<void> loadData() async {
    final response = await HttpUtils.get('top/playlist/highquality');
    final result = response.data as Map<String, dynamic>;

    if (result['code'] == 200) {
      final List<dynamic> playlists = result['playlists'] as List<dynamic>;
      _playlists = playlists
          .map((e) => Playlist.fromMap(e as Map<String, dynamic>))
          .toList();
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _playlists.length,
      itemBuilder: (context, index) {
        final playlist = _playlists[index];
        return ListTile(
          leading: CachedNetworkImage(
            httpHeaders:
                Map<String, String>.from({"User-Agent": bytesUserAgent}),
            imageUrl: "${playlist.coverImgUrl}?param=48y48",
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          title: Text(
            playlist.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            playlist.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(formatPlayCount(playlist.playCount)),
          onTap: () {
            Get.toNamed(RouterContants.playlistDetail, arguments: playlist.id);
          },
        );
      },
    );
  }

  String formatPlayCount(int playcount) {
    if (playcount > 10000) {
      return "${(playcount / 10000).toStringAsFixed(1)}万";
    }
    return playcount.toString();
  }
}
