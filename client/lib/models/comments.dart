import 'package:found_adoption_application/models/pet_center.dart';
import 'package:found_adoption_application/models/user.dart';

class Comment {
  final String id;
  User? userId;
  PetCenter? centerId;
  final String? commentId;
  final String content;
  final String createdAt;

  Comment(
      {required this.id,
      this.userId,
      this.centerId,
      this.commentId,
      required this.content,
      required this.createdAt});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['_id'],
        userId: json['userId'] != null
            ? User(
                id: json['userId']['_id'] as String,
                firstName: json['userId']['firstName'] as String,
                lastName: json['userId']['lastName'] as String,
                avatar: json['userId']['avatar'] as String,
                address: json['userId']['address'] as String,
                phoneNumber: json['userId']['phoneNumber'] as String,
              )
            : null,
        centerId: json['centerId'] != null
            ? PetCenter(
                id: json['centerId']['_id'] as String,
                name: json['centerId']['name'] as String,
                avatar: json['centerId']['avatar'] as String,
                address: json['centerId']['address'] as String,
                phoneNumber: json['centerId']['phoneNumber'] as String,
              )
            : null,
        commentId: json['commentId'] ?? null,
        content: json['content'] ?? '',
        createdAt: json['createdAt']);
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'userId': userId?.toMap(), // Đảm bảo cũng có hàm toMap trong class User
      'centerId':
          centerId?.toMap(), // Đảm bảo cũng có hàm toMap trong class PetCenter
      'commentId': commentId,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
