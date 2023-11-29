import 'package:found_adoption_application/models/pet_center.dart';
import 'package:found_adoption_application/models/user.dart';

class Like {
  final String id;
  final User? userId;
  final PetCenter? centerId;
  Like({
    required this.id,
    required this.userId,
    required this.centerId,
  });
  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['_id'],
      userId: json['userId'] != null
          ? User(
              id: json['userId']['_id'] as String,
              firstName: json['userId']['firstName'] as String,
              lastName: json['userId']['lastName'] as String,
              avatar: json['userId']['avatar'] as String,
            )
          : null,
      centerId: json['centerId'] != null
          ? PetCenter(
              id: json['centerId']['_id'] as String,
              name: json['centerId']['name'] as String,
              avatar: json['centerId']['avatar'] as String,
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'userId': userId?.toMap(), // Đảm bảo cũng có hàm toMap trong class User
      'centerId':
          centerId?.toMap(), // Đảm bảo cũng có hàm toMap trong class PetCenter
    };
  }
}
