import 'package:found_adoption_application/models/userId_centerId.dart';
import 'package:intl/intl.dart';

class Notify {
  final String id;
  final String title;
  final List<UserId_CenterId>? receiver;
  final String name;
  final String avatar;
  final String content;
  final String? idDestinate;
  final bool? allowView;
  final bool? read;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
    var receiverList = json['receiver'] as List<dynamic>;
    return Notify(
      id: json['_id'] as String,
      title: json['title'] as String,
      receiver:
          receiverList.map((json) => UserId_CenterId.fromJson(json)).toList(),
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      content: json['content'] as String,
      idDestinate: json['idDestinate'] as String,
      allowView: json['allowView'] as bool,
      read: json['read'] as bool,
      createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['createdAt']))
          .add(Duration(hours: 7)),
      updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['updatedAt']))
          .add(Duration(hours: 7)),
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
