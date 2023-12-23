import 'package:flutter/material.dart';

import 'package:qianshi_music/widgets/follows/follow_user_view.dart';
import 'package:qianshi_music/widgets/follows/followed_user_view.dart';
import 'package:qianshi_music/widgets/keep_alive_wrapper.dart';

class FollowsPage extends StatefulWidget {
  final int uid;
  final int pageIndex;
  const FollowsPage({
    Key? key,
    this.pageIndex = 0,
    required this.uid,
  }) : super(key: key);

  @override
  State<FollowsPage> createState() => _FollowsPageState();
}

class _FollowsPageState extends State<FollowsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.pageIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('关注'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(
                    text: '关注',
                  ),
                  Tab(
                    text: '粉丝',
                  )
                ],
              ),
            )),
        body: TabBarView(
          controller: _tabController,
          children: [
            KeepAliveWrapper(child: FollowUserView(uid: widget.uid)),
            KeepAliveWrapper(child: FollowedUserView(uid: widget.uid)),
          ],
        ));
  }
}
