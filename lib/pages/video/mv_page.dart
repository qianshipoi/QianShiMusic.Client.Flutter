import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/models/mv.dart';
import 'package:qianshi_music/pages/video/mv_comment_view.dart';
import 'package:qianshi_music/provider/video_provider.dart';
import 'package:qianshi_music/utils/logger.dart';
import 'package:qianshi_music/widgets/video_player/video_player_bottom.dart';
import 'package:qianshi_music/widgets/video_player/video_player_center.dart';
import 'package:qianshi_music/widgets/video_player/video_player_gestures.dart';
import 'package:qianshi_music/widgets/video_player/video_player_top.dart';
import 'package:qianshi_music/widgets/video_player/video_player_utils.dart';

class MvPage extends StatefulWidget {
  final Mv mv;
  const MvPage(this.mv, {super.key});

  @override
  State<MvPage> createState() => _MvPageState();
}

class _MvPageState extends State<MvPage> with TickerProviderStateMixin {
  // 是否全屏
  bool get _isFullScreen =>
      MediaQuery.of(context).orientation == Orientation.landscape;
  Size get _window => MediaQueryData.fromView(View.of(context)).size;
  double get _width => _isFullScreen ? _window.width : _window.width;
  double get _height => _isFullScreen ? _window.height : _window.width * 9 / 16;
  Widget? _playerUI;
  VideoPlayerTop? _top;
  VideoPlayerBottom? _bottom;
  LockIcon? _lockIcon; // 控制是否沉浸式的widget
  late TabController _controller;

  Future<void> _getVideoInfo() async {
    final response = await VideoProvider.url(widget.mv.id);
    if (response.code != 200) {
      Get.snackbar('Error', response.msg!);
      return;
    }
    var url = response.data!.url;
    if (url.startsWith('http://')) {
      url = url.replaceFirst('http://', 'https://');
    }
    logger.i('mv url: $url');
    VideoPlayerUtils.playerHandle(url, autoPlay: false);
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
    _getVideoInfo();
    VideoPlayerUtils.initializedListener(
        key: this,
        listener: (initialize, widget) {
          if (initialize) {
            _top ??= VideoPlayerTop();
            _lockIcon ??= LockIcon(
              lockCallback: () {
                _top!.opacityCallback(!TempValue.isLocked);
                _bottom!.opacityCallback(!TempValue.isLocked);
              },
            );
            _bottom ??= VideoPlayerBottom();
            _playerUI = widget;
            if (!mounted) return;
            setState(() {});
          }
        });
  }

  @override
  void dispose() {
    VideoPlayerUtils.removeInitializedListener(this);
    VideoPlayerUtils.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullScreen
          ? null
          : AppBar(
              title: const Text("视频示例"),
            ),
      body: _isFullScreen
          ? safeAreaPlayerUI()
          : Column(
              children: [
                safeAreaPlayerUI(),
                PreferredSize(
                  preferredSize: const Size.fromHeight(40),
                  child: _buildTabBar(),
                ),
                Expanded(
                  child: _buildTabBarPageView(),
                )
              ],
            ),
    );
  }

  _buildTabBarPageView() {
    return TabBarView(
      controller: _controller,
      children: [
        const Text('简介'),
        MvCommentView(mvId: widget.mv.id),
      ],
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _controller,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0xff2fcfbb), width: 3),
        insets: EdgeInsets.fromLTRB(0, 0, 0, 10),
      ),
      tabs: const [
        Tab(text: '简介'),
        Tab(text: '评论'),
      ],
    );
  }

  Widget safeAreaPlayerUI() {
    return SafeArea(
      // 全屏的安全区域
      top: !_isFullScreen,
      bottom: !_isFullScreen,
      left: !_isFullScreen,
      right: !_isFullScreen,
      child: SizedBox(
          height: _height,
          width: _width,
          child: _playerUI != null
              ? VideoPlayerGestures(
                  appearCallback: (appear) {
                    _top!.opacityCallback(appear);
                    _lockIcon!.opacityCallback(appear);
                    _bottom!.opacityCallback(appear);
                  },
                  children: [
                    Center(
                      child: _playerUI,
                    ),
                    _top!,
                    _lockIcon!,
                    _bottom!
                  ],
                )
              : Container(
                  alignment: Alignment.center,
                  color: Colors.black26,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                )),
    );
  }
}
