// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

class Lyric {
  final int version;
  final String lyric;
  Lyric({
    required this.version,
    required this.lyric,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'version': version,
      'lyric': lyric,
    };
  }

  factory Lyric.fromMap(Map<String, dynamic> map) {
    return Lyric(
      version: map['version'] as int,
      lyric: map['lyric'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Lyric.fromJson(String source) => Lyric.fromMap(json.decode(source) as Map<String, dynamic>);
}
