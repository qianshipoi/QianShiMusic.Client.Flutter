import 'dart:ui' as ui;

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/locale/globalization.dart';
import 'package:qianshi_music/main.dart';
import 'package:qianshi_music/pages/home/index_page.dart';
import 'package:qianshi_music/pages/home/my_page.dart';
import 'package:qianshi_music/stores/index_controller.dart';
import 'package:qianshi_music/stores/playing_controller.dart';
import 'package:qianshi_music/utils/capture_util.dart';
import 'package:qianshi_music/utils/circle_image_painter.dart';
import 'package:qianshi_music/utils/sputils.dart';
import 'package:qianshi_music/widgets/keep_alive_wrapper.dart';
import 'package:qianshi_music/widgets/playing_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final pages = [const IndexPage(), const MyPage()];
  final List<Widget> bottomItems = [
    const Icon(Icons.message, size: 30),
    const Icon(Icons.person, size: 30),
  ];
  int _currentPage = 0;
  final _boundaryKey = GlobalKey();
  ui.Image? _image;
  late AnimationController _controller;
  late Animation<double> _animation;
  final GlobalKey _keyGreen = GlobalKey();
  late Offset _startOffset;
  final _indexController = Get.find<IndexController>();
  final PlayingController _playingController = Get.find<PlayingController>();
  final PageController _pageController = PageController();

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
    if (image == null) {
      return;
    }
    _startOffset = CaptureUtil.getWidgetOffset(_keyGreen);
    setState(() {
      _image = image;
    });
    Future.delayed(Duration.zero, () {
      _controller.forward();
    });
  }

  Future<void> _switchTheme() async {
    await _captureWidget();
    if (_indexController.useSystemTheme.value) {
      var isDarkTheme = Get.isDarkMode;
      _indexController.useSystemTheme.value = false;
      if (isDarkTheme) {
        _indexController.useDarkTheme.value = false;
      } else {
        _indexController.useDarkTheme.value = true;
      }
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
                    onTap: () {
                      Get.toNamed(RouterContants.settings);
                    },
                    title: Text(Globalization.settings.tr),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                  ),
                  ListTile(
                    title: Text(Globalization.logout.tr),
                    onTap: () {
                      SpUtil().setBool('IsLogin', false);
                      jar.deleteAll();
                      Get.offNamed(RouterContants.login);
                    },
                  )
                ],
              ),
            ),
            bottomNavigationBar: Obx(
              () => SizedBox(
                height:
                    _playingController.currentTrack.value == null ? 60 : 120,
                child: Container(
                  color: const Color.fromARGB(255, 187, 230, 243),
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
                          items: [
                            Icon(Icons.message,
                                size: 24,
                                color: Theme.of(context).colorScheme.onPrimary),
                            Icon(Icons.person,
                                size: 24,
                                color: Theme.of(context).colorScheme.onPrimary),
                          ],
                          index: _currentPage,
                          backgroundColor:
                              const Color.fromARGB(255, 187, 230, 243),
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
            ),
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
                color:
                    Theme.of(context).colorScheme.onBackground.withOpacity(.1),
                borderRadius: BorderRadius.circular(5)),
            child: Center(
                child: Text(
              "搜索",
              style: Theme.of(context).textTheme.titleMedium,
            )),
          ),
        );
      default:
        return const Text("Music");
    }
  }

  DrawerHeader _buildDrawerHeader() {
    return DrawerHeader(
      child: Container(
        alignment: Alignment.topLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipOval(
              child: Image.network(
                AssetsContants.defaultAvatar,
                width: 60,
                fit: BoxFit.cover,
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
        });
  }
}
