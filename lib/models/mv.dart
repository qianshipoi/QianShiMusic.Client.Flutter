import 'dart:convert';

class Mv {
  final int id;
  final String cover;
  final String name;
  final int playCount;
  final int duration;
  final String artistName;
  final int artistId;
  Mv({
    required this.id,
    required this.cover,
    required this.name,
    required this.playCount,
    required this.duration,
    required this.artistName,
    required this.artistId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'cover': cover,
      'name': name,
      'playCount': playCount,
      'duration': duration,
      'artistName': artistName,
      'artistId': artistId,
    };
  }

  factory Mv.fromMap(Map<String, dynamic> map) {
    return Mv(
      id: map['id'] as int,
      cover: map['cover'] as String,
      name: map['name'] as String,
      playCount: map['playCount'] as int,
      duration: map['duration'] as int,
      artistName: map['artistName'] as String,
      artistId: map['artistId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Mv.fromJson(String source) =>
      Mv.fromMap(json.decode(source) as Map<String, dynamic>);
}
