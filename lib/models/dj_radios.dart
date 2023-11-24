import 'dart:convert';

class DjRadios {
  final int id;
  final String name;
  final String picUrl;
  final String desc;
  final int subCount;
  final int programCount;
  DjRadios({
    required this.id,
    required this.name,
    required this.picUrl,
    required this.desc,
    required this.subCount,
    required this.programCount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'picUrl': picUrl,
      'desc': desc,
      'subCount': subCount,
      'programCount': programCount,
    };
  }

  factory DjRadios.fromMap(Map<String, dynamic> map) {
    return DjRadios(
      id: map['id'] as int,
      name: map['name'] as String,
      picUrl: map['picUrl'] as String,
      desc: map['desc'] as String,
      subCount: map['subCount'] as int,
      programCount: map['programCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory DjRadios.fromJson(String source) =>
      DjRadios.fromMap(json.decode(source) as Map<String, dynamic>);
}
