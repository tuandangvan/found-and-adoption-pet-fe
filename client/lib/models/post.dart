import 'package:found_adoption_application/models/user.dart';

class Post {
  final String id;
  final User userId;
  // final String centerId;
  final String content;
  final List<dynamic> images;

  const Post({
    required this.id,
    required this.userId,
    // required this.centerId,
    required this.content,
    required this.images,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['data']['_id'] as String,

      userId: User(
        id: json['data']['userId']['_id'] as String,
        firstName: json['data']['userId']['firstName'] as String,
        lastName: json['data']['userId']['lastName'] as String,
        avatar: json['data']['userId']['avatar'] as String,
      ),
      // centerId: json['data']['centerId'] as String,
      content: json['data']['content'] as String,
      images: json['data']['images'] as List<dynamic>,
    );
  }
}
