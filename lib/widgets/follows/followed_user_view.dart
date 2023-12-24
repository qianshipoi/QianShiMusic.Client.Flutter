import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:qianshi_music/models/user_profile.dart';
import 'package:qianshi_music/provider/user_provider.dart';
import 'package:qianshi_music/widgets/tiles/search_user_tile.dart';

class FollowedUserView extends StatefulWidget {
  final int uid;
  const FollowedUserView({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<FollowedUserView> createState() => _FollowedUserViewState();
}

class _FollowedUserViewState extends State<FollowedUserView> {
  final List<UserProfile> _users = <UserProfile>[];
  final _refreshController = RefreshController(initialRefresh: false);
  bool _more = true;
  int _offset = 0;
  final _limit = 20;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _onLoading();
    });
  }

  Future _onLoading() async {
    if (!_more) {
      _refreshController.loadNoData();
      return;
    }
    final response = await UserProvider.followeds(widget.uid,
        offset: _offset, limit: _limit);
    if (response.code != 200) {
      Get.snackbar("获取关注列表失败", response.msg!);
      return;
    }
    _users.addAll(response.followeds);
    _offset = _users.length;
    _more = response.more;
    setState(() {});
    _refreshController.loadComplete();
    if (!_more) {
      _refreshController.loadNoData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      enablePullDown: false,
      onLoading: _onLoading,
      child: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return SearchUserTile(
            userProfile: user,
            onTap: () {},
          );
        },
      ),
    );
  }
}
