class LyricItem {
  Duration startTime;
  Duration? endTime;
  final String text;
  double offset;
  LyricItem(this.text,
      {required this.startTime, this.endTime, this.offset = 0});

  static List<LyricItem> formatLyric(String lyricStr) {
    final List<LyricItem> result = [];
    final List<String> lines = lyricStr.split("\n");
    final RegExp regExp = RegExp(r"^\[(\d{2}):(\d{2})\.(\d{2,3})\]");
    for (final line in lines) {
      final List<String?> matches =
          regExp.firstMatch(line)?.groups([1, 2, 3]) ?? [];
      if (matches.isNotEmpty) {
        final int minute = int.parse(matches[0] ?? "0");
        final int second = int.parse(matches[1] ?? "0");
        final int millisecond = int.parse(matches[2] ?? "0");
        final Duration startTime = Duration(
          minutes: minute,
          seconds: second,
          milliseconds: millisecond,
        );
        final String text = line.replaceAll(regExp, "").trim();
        result.add(LyricItem(text, startTime: startTime));
      }
    }
    for (int i = 0; i < result.length; i++) {
      if (i < result.length - 1) {
        result[i].endTime = result[i + 1].startTime;
      }
    }
    return result;
  }

  static int findLyricIndex(double curDuration, List<LyricItem> lyrics) {
    for (int i = 0; i < lyrics.length; i++) {
      if (curDuration >= lyrics[i].startTime.inMilliseconds &&
          curDuration <= lyrics[i].endTime!.inMilliseconds) {
        return i;
      }
    }
    return 0;
  }

  @override
  String toString() =>
      'LyricItem(startTime: $startTime, endTime: $endTime, text: $text)';
}
