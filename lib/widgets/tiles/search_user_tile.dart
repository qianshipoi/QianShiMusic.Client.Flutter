import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/models/user_profile.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class SearchUserTile extends StatelessWidget {
  final UserProfile userProfile;
  final GestureTapCallback? onTap;
  const SearchUserTile({super.key, required this.userProfile, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: FixImage(
          imageUrl:
              formatMusicImageUrl(userProfile.avatarUrl, width: 64, height: 64),
          width: 64,
          height: 64,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        userProfile.nickname,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      trailing: Obx(
        () => (userProfile.followed.value)
            ? ElevatedButton.icon(
                onPressed: () {
                  userProfile.followed.value = true;
                },
                icon: const Icon(Icons.add),
                label: const Text('关注'),
              )
            : const Text('已关注'),
      ),
      onTap: onTap,
    );
  }
}
