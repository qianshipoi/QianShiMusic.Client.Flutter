import 'dart:convert';

class LoginAccount {
  final int id;
  String userName;
  int type;
  int status;
  int whitelistAuthority;
  int createTime;
  String salt;
  int tokenVersion;
  int ban;
  int vipType;
  int viptypeVersion;
  bool anonimousUser;
  bool uninitialized;
  LoginAccount({
    required this.id,
    required this.userName,
    required this.type,
    required this.status,
    required this.whitelistAuthority,
    required this.createTime,
    required this.salt,
    required this.tokenVersion,
    required this.ban,
    required this.vipType,
    required this.viptypeVersion,
    required this.anonimousUser,
    required this.uninitialized,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userName': userName,
      'type': type,
      'status': status,
      'whitelistAuthority': whitelistAuthority,
      'createTime': createTime,
      'salt': salt,
      'tokenVersion': tokenVersion,
      'ban': ban,
      'vipType': vipType,
      'viptypeVersion': viptypeVersion,
      'anonimousUser': anonimousUser,
      'uninitialized': uninitialized,
    };
  }

  factory LoginAccount.fromMap(Map<String, dynamic> map) {
    return LoginAccount(
      id: map['id'] as int,
      userName: map['userName'] as String,
      type: map['type'] as int,
      status: map['status'] as int,
      whitelistAuthority: map['whitelistAuthority'] as int,
      createTime: map['createTime'] as int,
      salt: map['salt'] as String,
      tokenVersion: map['tokenVersion'] as int,
      ban: map['ban'] as int,
      vipType: map['vipType'] as int,
      viptypeVersion: map['viptypeVersion'] as int,
      anonimousUser: map['anonimousUser'] as bool,
      uninitialized: map['uninitialized'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginAccount.fromJson(String source) =>
      LoginAccount.fromMap(json.decode(source) as Map<String, dynamic>);
}
