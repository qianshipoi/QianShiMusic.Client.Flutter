import 'dart:convert';

class Album {
  final int id;
  final String name;
  final String? picUrl;

  Album(
    this.id,
    this.name,
    this.picUrl,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'picUrl': picUrl,
    };
  }

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      map['id'] as int,
      map['name'] as String,
      map['picUrl'] != null ? map['picUrl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Album.fromJson(String source) =>
      Album.fromMap(json.decode(source) as Map<String, dynamic>);
}
