import 'dart:ffi';

import 'package:found_adoption_application/models/userId_centerId.dart';

class Notify {
  final String id;
  final String title;
  final List<UserId_CenterId>? receiver;
  final String name;
  final String avatar;
  final String content;
  final Bool? idDestinate;
  final String? allowView;
  final Bool? read;
  final String? createdAt;
  final String? updatedAt;

  Notify(
      {required this.id,
      required this.title,
      required this.receiver,
      required this.name,
      required this.avatar,
      required this.content,
      this.idDestinate,
      this.allowView,
      this.read,
      this.createdAt,
      this.updatedAt});

  factory Notify.fromJson(Map<String, dynamic> json) {
    return Notify(
      id: json['_id'] as String,
      title: json['title'] as String,
      receiver: json['receiver'] as List<UserId_CenterId>,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      content: json['content'] as String,
      idDestinate: json['idDestinate'] as Bool,
      allowView: json['allowView'] as String,
      read: json['read'] as Bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'receiver': receiver,
      'name': name,
      'avatar': avatar,
      'content': content,
      'idDestinate': idDestinate,
      'allowView': allowView,
      'read': read,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}
