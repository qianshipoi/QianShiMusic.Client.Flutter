import 'dart:convert';

class SongUrl {
  final int id;
  final String? url;
  final int br;
  final int size;
  final String? md5;
  final int? code;
  final int? expi;
  final String? type;
  final int time;
  SongUrl({
    required this.id,
    this.url,
    required this.br,
    required this.size,
    this.md5,
    this.code,
    this.expi,
    this.type,
    required this.time,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'url': url,
      'br': br,
      'size': size,
      'md5': md5,
      'code': code,
      'expi': expi,
      'type': type,
      'time': time,
    };
  }

  factory SongUrl.fromMap(Map<String, dynamic> map) {
    return SongUrl(
      id: map['id'] as int,
      url: map['url'] != null ? map['url'] as String : null,
      br: map['br'] as int,
      size: map['size'] as int,
      md5: map['md5'] != null ? map['md5'] as String : null,
      code: map['code'] != null ? map['code'] as int : null,
      expi: map['expi'] != null ? map['expi'] as int : null,
      type: map['type'] != null ? map['type'] as String : null,
      time: map['time'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SongUrl.fromJson(String source) =>
      SongUrl.fromMap(json.decode(source) as Map<String, dynamic>);
}
