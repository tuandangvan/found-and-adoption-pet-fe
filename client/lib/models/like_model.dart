import 'package:found_adoption_application/models/pet_center.dart';
import 'package:found_adoption_application/models/user.dart';
import 'package:intl/intl.dart';

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
              address: json['userId']['address'] as String,
              phoneNumber: json['userId']['phoneNumber'] as String,
              aboutMe: json['userId']['aboutMe'] as String,
              createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                      .parse(json['userId']['createdAt']))
                  .add(Duration(hours: 7)),
              updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss")
                      .parse(json['userId']['updatedAt']))
                  .add(Duration(hours: 7)),
            )
          : null,
      centerId: json['centerId'] != null
          ? PetCenter(
              id: json['centerId']['_id'] as String,
              name: json['centerId']['name'] as String,
              avatar: json['centerId']['avatar'] as String,
              address: json['centerId']['address'] as String,
              phoneNumber: json['centerId']['phoneNumber'] as String,
              aboutMe: json['centerId']['aboutMe'] as String,
              createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['centerId']['createdAt']))
          .add(Duration(hours: 7)),
              updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['centerId']['createdAt']))
          .add(Duration(hours: 7)),
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
