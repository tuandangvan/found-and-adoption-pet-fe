import 'package:found_adoption_application/models/comments.dart';
import 'package:found_adoption_application/models/pet_center.dart';
import 'package:found_adoption_application/models/user.dart';
import 'package:intl/intl.dart';

class Post {
  final String id;
  User? userId;
  PetCenter? petCenterId;
  final String content;
  List<dynamic>? images;
  List<Comment>? comments;
  List<dynamic>? reaction;
  String? status;
  DateTime createdAt;

  Post(
      {required this.id,
      this.userId,
      this.petCenterId,
      required this.content,
      this.images,
      this.comments,
      this.reaction,
      required this.createdAt,
      required this.status});

  factory Post.fromJson(Map<String, dynamic> json) {
    var commentList = json['comments'] as List<dynamic>;
    return Post(
      id: json['_id'] as String,
      userId: json['userId'] != null
          ? User(
              id: json['userId']['_id'] as String,
              firstName: json['userId']['firstName'] as String,
              lastName: json['userId']['lastName'] as String,
              avatar: json['userId']['avatar'] as String,
              address: json['userId']['address'] as String,
              phoneNumber: json['userId']['phoneNumber'] as String,
              aboutMe: json['userId']['aboutMe'] as String,
              createdAt: json['userId']['createdAt'] as String,
              updatedAt: json['userId']['updatedAt'] as String,
            )
          : null,
      petCenterId: json['centerId'] != null
          ? PetCenter(
              id: json['centerId']['_id'] as String,
              name: json['centerId']['name'] as String,
              avatar: json['centerId']['avatar'] as String,
              address: json['centerId']['address'] as String,
              phoneNumber: json['centerId']['phoneNumber'] as String,
              aboutMe: json['centerId']['aboutMe'] as String,
              createdAt: json['centerId']['createdAt'] as String,
              updatedAt: json['centerId']['updatedAt'] as String,
            )
          : null,
      content: json['content'] as String,
      images: json['images'] as List<dynamic>,
      reaction: json['reaction'] as List<dynamic>,
      comments: commentList.map((json) => Comment.fromJson(json)).toList(),
      createdAt:
          DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").parse(json['createdAt']),
      status: json['status'],
    );
  }
}
