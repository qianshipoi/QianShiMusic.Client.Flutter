import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/constants.dart';

import 'package:qianshi_music/models/comment.dart';
import 'package:qianshi_music/pages/user_page.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final Function()? replyTap;
  final Function()? likeTap;
  const CommentItem({
    super.key,
    required this.comment,
    this.replyTap,
    this.likeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, right: 8),
            child: GestureDetector(
              onTap: () {
                Get.to(() => UserPage(
                      uid: comment.user.userId,
                    ));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: FixImage(
                    imageUrl:
                        formatMusicImageUrl(comment.user.avatarUrl, size: 40),
                    width: 40,
                    height: 40),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 56,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment.user.nickname,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              comment.timeStr,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      _buildLike(context),
                    ],
                  ),
                ),
                Text(comment.content),
                _buildReply(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLike(BuildContext context) {
    if (likeTap == null) return const SizedBox.shrink();
    return Row(
      children: [
        Text(
          comment.likedCount.toString(),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        IconButton(
          iconSize: 18,
          selectedIcon: const Icon(
            Icons.favorite,
            color: Colors.redAccent,
          ),
          isSelected: comment.liked,
          onPressed: likeTap,
          icon: const Icon(Icons.favorite_border),
        ),
      ],
    );
  }

  Widget _buildReply(BuildContext context) {
    if (comment.replyCount == 0 || replyTap == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: GestureDetector(
        onTap: replyTap,
        child: Text(
          "${comment.replyCount}条回复 >",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ),
    );
  }
}
