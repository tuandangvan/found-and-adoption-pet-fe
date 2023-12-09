class User {
  final String id;
  final String firstName;
  final String lastName;
  final String avatar;
  final String? address;
  final String? phoneNumber;
  final String? email;
  final String? status;
  final String? aboutMe;
  final String? createdAt;
  final String? updatedAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.address,
    required this.phoneNumber,
    this.email,
    this.status,
    this.aboutMe,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'avatar': avatar,
      'address': address,
      'phoneNumber': phoneNumber,
      'email': email,
      'status': status,
      'aboutMe': aboutMe,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}
