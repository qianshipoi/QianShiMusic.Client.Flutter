import 'dart:ui' as ui;

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/locale/globalization.dart';
import 'package:qianshi_music/pages/home/index_page.dart';
import 'package:qianshi_music/pages/home/my_page.dart';
import 'package:qianshi_music/stores/current_user_controller.dart';
import 'package:qianshi_music/stores/index_controller.dart';
import 'package:qianshi_music/stores/playing_controller.dart';
import 'package:qianshi_music/utils/capture_util.dart';
import 'package:qianshi_music/utils/circle_image_painter.dart';
import 'package:qianshi_music/utils/sputils.dart';
import 'package:qianshi_music/widgets/fix_image.dart';
import 'package:qianshi_music/widgets/keep_alive_wrapper.dart';
import 'package:qianshi_music/widgets/playing_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class HomeBottomItem {
  final String title;
  final IconData icon;

  const HomeBottomItem(this.title, this.icon);
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final pages = [const IndexPage(), const MyPage()];
  final List<HomeBottomItem> _bottomItems = [
    const HomeBottomItem("首页", Icons.home),
    const HomeBottomItem("我的", Icons.person),
  ];
  int _currentPage = 0;
  final _boundaryKey = GlobalKey();
  ui.Image? _image;
  late AnimationController _controller;
  late Animation<double> _animation;
  final GlobalKey _keyGreen = GlobalKey();
  late Offset _startOffset;
  final IndexController _indexController = Get.find();
  final PlayingController _playingController = Get.find();
  final CurrentUserController _currentUserController = Get.find();
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 100).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _image = null;
          _controller.reset();
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _captureWidget() async {
    var image = await CaptureUtil.captureWidget(
        _boundaryKey, MediaQuery.of(context).devicePixelRatio);
    if (image == null) return;
    _startOffset = CaptureUtil.getWidgetOffset(_keyGreen);
    setState(() {
      _image = image;
    });
    Future.delayed(Duration.zero, _controller.forward);
  }

  Future<void> _switchTheme() async {
    await _captureWidget();
    if (_indexController.useSystemTheme.value) {
      _indexController.useSystemTheme.value = false;
      _indexController.useDarkTheme.value = !Get.isDarkMode;
    } else {
      _indexController.useDarkTheme.value =
          !_indexController.useDarkTheme.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _boundaryKey,
      child: Stack(
        children: [
          Scaffold(
            appBar: _buildAppBar(),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerHeader(),
                  ListTile(
                    onTap: () => Get.toNamed(RouterContants.settings),
                    title: Text(Globalization.settings.tr),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                  ListTile(
                    title: Text(Globalization.logout.tr),
                    onTap: () {
                      SpUtil().setBool('IsLogin', false);
                      Get.offNamed(RouterContants.login);
                    },
                  )
                ],
              ),
            ),
            bottomNavigationBar: _buildNavigationBar(context),
            backgroundColor: Colors.transparent,
            body: PageView(
              controller: _pageController,
              children: pages.map((e) => KeepAliveWrapper(child: e)).toList(),
              onPageChanged: (value) {
                setState(() {
                  _currentPage = value;
                });
              },
            ),
          ),
          _buildImageFromBytes()
        ],
      ),
    );
  }

  Obx _buildNavigationBar(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: _playingController.currentTrack.value == null ? 60 : 120,
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              Obx(() {
                return _playingController.currentTrack.value == null
                    ? const SizedBox(height: 10)
                    : const PlayingBar(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      );
              }),
              CurvedNavigationBar(
                  items: _bottomItems
                      .map((e) => Icon(
                            e.icon,
                            size: 24,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ))
                      .toList(),
                  index: _currentPage,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  color: Theme.of(context).colorScheme.primary,
                  height: 50,
                  onTap: (index) {
                    setState(() {
                      _currentPage = index;
                      _pageController.jumpToPage(index);
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: _buildAppBarTitle(),
      actions: [
        PopupMenuButton(itemBuilder: (context) {
          return [
            PopupMenuItem<int>(
              value: 0,
              child: Row(
                children: [
                  const Icon(Icons.search),
                  Text(Globalization.search.tr),
                ],
              ),
            ),
          ];
        }, onSelected: (value) {
          if (value == 0) {
            Get.toNamed(RouterContants.search);
          }
        }),
      ],
    );
  }

  Widget _buildAppBarTitle() {
    switch (_currentPage) {
      case 0:
        return GestureDetector(
          onTap: () {
            Get.toNamed(RouterContants.search);
          },
          child: Container(
            width: double.infinity,
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onBackground.withOpacity(.1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                "搜索",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        );
      default:
        return Text(_bottomItems[_currentPage].title);
    }
  }

  DrawerHeader _buildDrawerHeader() {
    var avatarUrl = _currentUserController.currentProfile.value?.avatarUrl;
    if (avatarUrl == null) {
      avatarUrl = AssetsContants.defaultAvatar;
    } else {
      avatarUrl = formatMusicImageUrl(avatarUrl, size: 60);
    }
    return DrawerHeader(
      child: Container(
        alignment: Alignment.topLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipOval(
              child: FixImage(
                imageUrl: avatarUrl,
                width: 60,
                height: 60,
              ),
            ),
            IconButton(
              key: _keyGreen,
              onPressed: () => _switchTheme(),
              icon: const Icon(Icons.brightness_4),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImageFromBytes() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        if (_image == null) {
          return const SizedBox.shrink();
        }

        return Positioned.fill(
          child: CustomPaint(
            size: MediaQuery.of(context).size,
            painter:
                CircleImagePainter(_image!, _animation.value, _startOffset),
          ),
        );
      },
    );
  }
}
