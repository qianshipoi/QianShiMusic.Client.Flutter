import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qianshi_music/models/comment.dart';
import 'package:qianshi_music/models/responses/comment/comment_new_mv_response.dart';
import 'package:qianshi_music/pages/video/comment_item.dart';
import 'package:qianshi_music/provider/comment_provider.dart';
import 'package:qianshi_music/utils/logger.dart';

class MvCommentView extends StatefulWidget {
  final int mvId;
  const MvCommentView({
    Key? key,
    required this.mvId,
  }) : super(key: key);

  @override
  State<MvCommentView> createState() => _MvCommentViewState();
}

class _MvCommentViewState extends State<MvCommentView> {
  final List<Comment> _comments = [];
  final _refreshController = RefreshController(initialRefresh: false);
  int get id => widget.mvId;
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
    final response = await CommentProvider.new_<CommentNewMvResponse>(id,
        pageNo: _page, pageSize: _limit, sortType: _sortType);

    if (response.code != 200) {
      Get.snackbar('Error', response.msg!);
      return;
    }

    logger.i(response.data!.hasMore);

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
        itemBuilder: (context, index) => CommentItem(comment: _comments[index]),
      ),
    );
  }
}
