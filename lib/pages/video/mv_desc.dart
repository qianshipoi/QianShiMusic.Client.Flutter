import 'package:flutter/material.dart';
import 'package:qianshi_music/constants.dart';

import 'package:qianshi_music/models/mv.dart';
import 'package:qianshi_music/provider/mv_provider.dart';

class MvDesc extends StatefulWidget {
  final Mv mv;

  const MvDesc({
    Key? key,
    required this.mv,
  }) : super(key: key);

  @override
  State<MvDesc> createState() => _MvDescState();
}

class _MvDescState extends State<MvDesc> {
  Mv? mv;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getMvDetail();
    });
  }

  Future<void> _getMvDetail() async {
    final response = await MvProvider.detail(widget.mv.id);
    if (response.code != 200) {
      return;
    }
    setState(() {
      mv = response.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (mv == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  mv!.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Column(children: [
                const Icon(
                  Icons.thumb_up,
                  size: 20,
                  color: Colors.grey,
                ),
                Text(
                  formatPlaycount(mv!.playCount),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ]),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '简介：${mv!.briefDesc}',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
