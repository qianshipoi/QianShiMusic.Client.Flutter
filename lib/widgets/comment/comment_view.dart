import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:qianshi_music/models/comment.dart';
import 'package:qianshi_music/provider/comment_provider.dart';
import 'package:qianshi_music/widgets/comment/comment_item.dart';

class CommentView extends StatefulWidget {
  final int id;
  final int type;
  const CommentView({
    Key? key,
    required this.type,
    required this.id,
  }) : super(key: key);

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  final List<Comment> _comments = [];
  final _refreshController = RefreshController(initialRefresh: false);
  int get id => widget.id;
  int get type => widget.type;
  int _page = 1;
  final _limit = 20;
  bool more = true;
  final _sortType = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshController.requestLoading();
    });
  }

  Future _onLoading() async {
    if (!more) {
      _refreshController.loadNoData();
      return;
    }
    final response = await CommentProvider.new_(
      id,
      type,
      pageNo: _page,
      pageSize: _limit,
      sortType: _sortType,
    );

    if (response.code != 200) {
      Get.snackbar('Error', response.msg!);
      return;
    }
    _comments.addAll(response.data!.comments);
    more = response.data!.hasMore;
    _page++;
    _refreshController.loadComplete();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullUp: true,
      enablePullDown: false,
      controller: _refreshController,
      onLoading: _onLoading,
      child: ListView.builder(
        itemCount: _comments.length,
        itemBuilder: (context, index) => CommentItem(
          comment: _comments[index],
          replyTap: () {
            Get.bottomSheet(
              CommentFloorView(
                id: id,
                parentCommentId: _comments[index].commentId,
                type: type,
              ),
              backgroundColor: Theme.of(context).colorScheme.background,
            );
          },
        ),
      ),
    );
  }
}

class CommentFloorView extends StatefulWidget {
  final int id;
  final int parentCommentId;
  final int type;
  const CommentFloorView({
    super.key,
    required this.id,
    required this.parentCommentId,
    required this.type,
  });

  @override
  State<CommentFloorView> createState() => _CommentFloorViewState();
}

class _CommentFloorViewState extends State<CommentFloorView> {
  final List<Comment> _comments = [];
  final _refreshController = RefreshController(initialRefresh: false);
  int get id => widget.id;
  int get parentCommentId => widget.parentCommentId;
  int get type => widget.type;
  final _limit = 20;
  int _time = 0;
  bool _more = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _refreshController.requestLoading();
    });
  }

  Future _onLoading() async {
    if (!_more) return;
    final response = await CommentProvider.floor(
      id,
      type,
      parentCommentId,
      limit: _limit,
      time: _time == 0 ? null : _time,
    );

    if (response.code != 200) {
      Get.snackbar('Error', response.msg!);
      return;
    }
    _comments.addAll(response.data!.comments);
    _more = response.data!.hasMore;
    _time = response.data!.time;
    _refreshController.loadComplete();
    if (!_more) {
      _refreshController.loadNoData();
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullUp: true,
      enablePullDown: false,
      controller: _refreshController,
      onLoading: _onLoading,
      child: ListView.builder(
        itemCount: _comments.length,
        itemBuilder: (context, index) => CommentItem(comment: _comments[index]),
      ),
    );
  }
}
