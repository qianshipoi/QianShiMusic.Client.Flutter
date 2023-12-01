import 'dart:ui' as prefix0;
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:qianshi_music/models/lyric_item.dart';
import 'package:qianshi_music/widgets/common_text_style.dart';

// code from: https://github.com/fluttercandies/NeteaseCloudMusic/blob/7056857af55c0e308a088379a5b2bfbfaefea7b5/netease_cloud_music/lib/pages/play_songs/widget_lyric.dart
class LyricWidget extends CustomPainter with ChangeNotifier {
  List<LyricItem> lyric;
  List<TextPainter> lyricPaints = []; // 其他歌词
  double _offsetY = 0;
  int curLine;
  late Paint linePaint;
  bool isDragging = false; // 是否正在人为拖动
  double totalHeight = 0; // 总长度
  late TextPainter draggingLineTimeTextPainter; // 正在拖动中当前行的时间
  Size canvasSize = Size.zero;
  late int dragLineTime;

  double get offsetY => _offsetY;

  set offsetY(double value) {
    // 判断如果是在拖动状态下
    if (isDragging) {
      // 不能小于最开始的位置
      if (_offsetY.abs() < lyricPaints[0].height + ScreenUtil().setWidth(30)) {
        _offsetY = (lyricPaints[0].height + ScreenUtil().setWidth(30)) * -1;
      } else if (_offsetY.abs() >
          (totalHeight + lyricPaints[0].height + ScreenUtil().setWidth(30))) {
        // 不能大于最大位置
        _offsetY =
            (totalHeight + lyricPaints[0].height + ScreenUtil().setWidth(30)) *
                -1;
      } else {
        _offsetY = value;
      }
    } else {
      _offsetY = value;
    }
    notifyListeners();
  }

  LyricWidget(this.lyric, this.curLine) {
    linePaint = Paint()
      ..color = Colors.white12
      ..strokeWidth = ScreenUtil().setWidth(1);
    lyricPaints.addAll(lyric
        .map((l) => TextPainter(
            text: TextSpan(text: l.text, style: commonGrayTextStyle),
            textDirection: TextDirection.ltr))
        .toList());
    // 首先对TextPainter 进行 layout，否则会报错
    _layoutTextPainters();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvasSize = size;
    var y = _offsetY + size.height / 2 + lyricPaints[0].height / 2;

    for (int i = 0; i < lyric.length; i++) {
      if (y > size.height || y < (0 - lyricPaints[i].height / 2)) {
      } else {
        // 画每一行歌词
        if (curLine == i) {
          // 如果是当前行
          lyricPaints[i].text =
              TextSpan(text: lyric[i].text, style: commonGrayTextStyle);
          lyricPaints[i].layout();
        } else if (isDragging &&
            i ==
                (_offsetY / (lyricPaints[0].height + ScreenUtil().setWidth(30)))
                        .abs()
                        .round() -
                    1) {
          // 如果是拖动状态中的当前行
          lyricPaints[i].text =
              TextSpan(text: lyric[i].text, style: commonGrayTextStyle);
          lyricPaints[i].layout();
        } else {
          lyricPaints[i].text =
              TextSpan(text: lyric[i].text, style: commonGrayTextStyle);
          lyricPaints[i].layout();
        }

        lyricPaints[i].paint(
          canvas,
          Offset((size.width - lyricPaints[i].width) / 2, y),
        );
      }
      // 计算偏移量
      y += lyricPaints[i].height + ScreenUtil().setWidth(30);
      lyric[i].offset = y;
    }

    // 拖动状态下显示的东西
    if (isDragging) {
      // 画 icon
      const icon = Icons.play_arrow;
      var builder = prefix0.ParagraphBuilder(prefix0.ParagraphStyle(
        fontFamily: icon.fontFamily,
        fontSize: ScreenUtil().setWidth(60),
      ))
        ..addText(String.fromCharCode(icon.codePoint));
      var para = builder.build();
      para.layout(prefix0.ParagraphConstraints(
        width: ScreenUtil().setWidth(60),
      ));
      canvas.drawParagraph(
          para,
          Offset(ScreenUtil().setWidth(10),
              size.height / 2 - ScreenUtil().setWidth(60)));

      // 画线
      canvas.drawLine(
          Offset(ScreenUtil().setWidth(80),
              size.height / 2 - ScreenUtil().setWidth(30)),
          Offset(size.width - ScreenUtil().setWidth(120),
              size.height / 2 - ScreenUtil().setWidth(30)),
          linePaint);
      // 画当前行的时间
      dragLineTime = lyric[
              (_offsetY / (lyricPaints[0].height + ScreenUtil().setWidth(30)))
                      .abs()
                      .round() -
                  1]
          .startTime
          .inMilliseconds;
      draggingLineTimeTextPainter = TextPainter(
        text: TextSpan(
            text: DateUtil.formatDateMs(dragLineTime, format: "mm:ss"),
            style: smallGrayTextStyle),
        textDirection: TextDirection.ltr,
      );
      draggingLineTimeTextPainter.layout();
      draggingLineTimeTextPainter.paint(
          canvas,
          Offset(size.width - ScreenUtil().setWidth(80),
              size.height / 2 - ScreenUtil().setWidth(45)));
    }
  }

  /// 计算传入行和第一行的偏移量
  double computeScrollY(int curLine) {
    return (lyricPaints[0].height + ScreenUtil().setWidth(30)) * (curLine + 1);
  }

  void _layoutTextPainters() {
    for (var lp in lyricPaints) {
      lp.layout();
    }

    // 延迟一下计算总高度
    Future.delayed(const Duration(milliseconds: 300), () {
      totalHeight = (lyricPaints[0].height + ScreenUtil().setWidth(30)) *
          (lyricPaints.length - 1);
    });
  }

  @override
  bool shouldRepaint(LyricWidget oldDelegate) {
    return oldDelegate._offsetY != _offsetY ||
        oldDelegate.isDragging != isDragging;
  }
}
