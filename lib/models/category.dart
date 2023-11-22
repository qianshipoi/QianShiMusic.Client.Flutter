// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Category {
  final int? id;
  final String name;
  final int type;
  final int? usedCount;
  final int? createTime;
  final int? resourceCount;
  final int? resourceType;
  final String? imgUrl;
  final int category;
  final int? position;
  final bool activity;
  final bool hot;
  Category({
    this.id,
    required this.name,
    required this.type,
    this.usedCount,
    this.createTime,
    this.resourceCount,
    this.resourceType,
    this.imgUrl,
    required this.category,
    this.position,
    required this.activity,
    required this.hot,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type,
      'usedCount': usedCount,
      'createTime': createTime,
      'resourceCount': resourceCount,
      'resourceType': resourceType,
      'imgUrl': imgUrl,
      'category': category,
      'position': position,
      'activity': activity,
      'hot': hot,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] as String,
      type: map['type'] as int,
      usedCount: map['usedCount'] != null ? map['usedCount'] as int : null,
      createTime: map['createTime'] != null ? map['createTime'] as int : null,
      resourceCount:
          map['resourceCount'] != null ? map['resourceCount'] as int : null,
      resourceType:
          map['resourceType'] != null ? map['resourceType'] as int : null,
      imgUrl: map['imgUrl'] != null ? map['imgUrl'] as String : null,
      category: map['category'] as int,
      position: map['position'] != null ? map['position'] as int : null,
      activity: map['activity'] as bool,
      hot: map['hot'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);
}
