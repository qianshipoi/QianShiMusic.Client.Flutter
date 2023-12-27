import 'package:flutter/material.dart';

class HorizontalTitleListView extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final double height;
  final ListView? listView;

  const HorizontalTitleListView({
    super.key,
    required this.title,
    this.onTap,
    this.height = 260,
    this.listView,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
                TextButton(onPressed: onTap, child: const Text('See All')),
              ],
            ),
          ),
          Expanded(
            child: listView ?? const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
