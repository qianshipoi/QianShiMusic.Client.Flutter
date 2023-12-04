import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/models/artist.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class SearchArtistTile extends StatelessWidget {
  final Artist artist;
  final GestureTapCallback? onTap;
  const SearchArtistTile({super.key, required this.artist, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: FixImage(
          imageUrl: formatMusicImageUrl(artist.picUrl, width: 64, height: 64),
          width: 64,
          height: 64,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        artist.name,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      trailing: Obx(() => (artist.followed.value ?? false)
          ? ElevatedButton.icon(
              onPressed: () {
                artist.followed.value = true;
              },
              icon: const Icon(Icons.add),
              label: const Text('关注'),
            )
          : const Text('已关注')),
      onTap: onTap,
    );
  }
}
