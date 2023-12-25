import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  int total = 0;

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
    total = response.data!.totalCount;
    _page++;
    _refreshController.loadComplete();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Text('评论($total)'),
            ),
          ],
        ),
        Expanded(
          child: SmartRefresher(
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
                      comment: _comments[index],
                    ),
                    backgroundColor: Theme.of(context).colorScheme.background,
                    isScrollControlled: true,
                  );
                },
                likeTap: () async {
                  final comment = _comments[index];
                  final isLike = !comment.liked;
                  final response = await CommentProvider.like(
                      id, comment.commentId, type,
                      isLike: isLike);
                  if (response.code != 200) {
                    Get.snackbar("点赞评论失败", response.msg!);
                    return;
                  }
                  _comments.removeAt(index);
                  _comments.insert(
                    index,
                    comment.copyWith(
                      liked: isLike,
                      likedCount: comment.likedCount + (isLike ? 1 : -1),
                    ),
                  );
                  setState(() {});
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CommentFloorView extends StatefulWidget {
  final int id;
  final int parentCommentId;
  final int type;
  final Comment comment;
  const CommentFloorView({
    super.key,
    required this.id,
    required this.parentCommentId,
    required this.type,
    required this.comment,
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
    return SizedBox(
      height: ScreenUtil().screenHeight * 0.8,
      child: Column(
        children: [
          CommentItem(comment: widget.comment),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10,
                ),
                child: Text('全部回复(${widget.comment.replyCount})'),
              ),
            ],
          ),
          Expanded(
            child: SmartRefresher(
              enablePullUp: true,
              enablePullDown: false,
              controller: _refreshController,
              onLoading: _onLoading,
              child: ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) => CommentItem(
                  comment: _comments[index],
                  likeTap: () async {
                    final comment = _comments[index];
                    final isLike = !comment.liked;
                    final response = await CommentProvider.like(
                        id, comment.commentId, type,
                        isLike: isLike);
                    if (response.code != 200) {
                      Get.snackbar("点赞评论失败", response.msg!);
                      return;
                    }
                    _comments.removeAt(index);
                    _comments.insert(
                        index,
                        comment.copyWith(
                          liked: isLike,
                          likedCount: comment.likedCount + (isLike ? 1 : -1),
                        ));
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
