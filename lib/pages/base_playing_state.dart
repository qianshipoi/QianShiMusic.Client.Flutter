import 'package:flutter/material.dart';
import 'package:qianshi_music/widgets/playing_bar.dart';

abstract class BasePlayingState<T extends StatefulWidget> extends State<T> {
  Color get backgroundColor => Theme.of(context).colorScheme.background;

  BorderRadius get borderRadius => const BorderRadius.all(Radius.circular(16));

  String get heroTag => DateTime.timestamp().toString();

  @override
  @mustCallSuper
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  @mustCallSuper
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          Expanded(child: buildPageBody(context)),
          PlayingBar(
            borderRadius: borderRadius,
            tag: heroTag,
          ),
        ],
      ),
    );
  }

  Widget buildPageBody(BuildContext context);
}
