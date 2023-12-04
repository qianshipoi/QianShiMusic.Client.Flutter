import 'dart:convert';

import 'package:get/get.dart';

class Artist {
  final int id;
  final String name;
  final String? picUrl;
  final int? albumSize;
  final int? mvSize;
  late Rx<bool?> followed;

  Artist({
    required this.id,
    required this.name,
    this.picUrl,
    this.albumSize,
    this.mvSize,
    bool? followed,
  }) {
    this.followed = followed.obs;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'picUrl': picUrl,
      'albumSize': albumSize,
      'mvSize': mvSize,
      'followed': followed.value,
    };
  }

  factory Artist.fromMap(Map<String, dynamic> map) {
    return Artist(
      id: map['id'] as int,
      name: map['name'] as String,
      picUrl: map['picUrl'] != null ? map['picUrl'] as String : null,
      albumSize: map['albumSize'] != null ? map['albumSize'] as int : null,
      mvSize: map['mvSize'] != null ? map['mvSize'] as int : null,
      followed: map['followed'] != null ? map['followed'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Artist.fromJson(String source) =>
      Artist.fromMap(json.decode(source) as Map<String, dynamic>);
}
