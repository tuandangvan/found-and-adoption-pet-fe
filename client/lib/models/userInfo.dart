import 'package:intl/intl.dart';

class InfoUser {
  final String id;
  final String accountId;
  final String email;
  final String role;
  final String status;
  final String firstName;
  final String lastName;
  final String avatar;
  final String phoneNumber;
  final String address;
  final bool experience;
  final String aboutMe;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const InfoUser({
    required this.id,
    required this.accountId,
    required this.email,
    required this.role,
    required this.status,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.phoneNumber,
    required this.address,
    required this.experience,
    required this.aboutMe,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method để tạo đối tượng InfoUser từ JSON
  factory InfoUser.fromJson(Map<String, dynamic> json) {
    return InfoUser(
      id: json['_id'] as String,
      accountId: json['accountId'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      avatar: json['avatar'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      experience: json['experience'] ? json['experience'] : false,
      aboutMe: json['aboutMe'] as String,
      createdAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['createdAt']))
          .add(Duration(hours: 7)),
      updatedAt: (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(json['updatedAt']))
          .add(Duration(hours: 7)),
    );
  }
}
