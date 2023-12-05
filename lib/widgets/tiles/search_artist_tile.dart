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
        borderRadius: BorderRadius.circular(999),
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
          ? const Text('已关注')
          : ElevatedButton.icon(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(48, 32)),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
              ),
              onPressed: () {
                artist.followed.value = true;
              },
              icon: const Icon(Icons.add),
              label: const Text('关注'),
            )),
      onTap: onTap,
    );
  }
}
