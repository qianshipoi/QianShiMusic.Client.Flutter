import 'dart:convert';

class Artist {
  final int id;
  final String name;
  final String picUrl;
  final int albumSize;
  final int mvSize;
  final bool followed;
  Artist({
    required this.id,
    required this.name,
    required this.picUrl,
    required this.albumSize,
    required this.mvSize,
    required this.followed,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'picUrl': picUrl,
      'albumSize': albumSize,
      'mvSize': mvSize,
      'followed': followed,
    };
  }

  factory Artist.fromMap(Map<String, dynamic> map) {
    return Artist(
      id: map['id'] as int,
      name: map['name'] as String,
      picUrl: map['picUrl'] as String,
      albumSize: map['albumSize'] as int,
      mvSize: map['mvSize'] as int,
      followed: map['followed'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Artist.fromJson(String source) =>
      Artist.fromMap(json.decode(source) as Map<String, dynamic>);
}
