class User {
  final String id;
  final String firstName;
  final String lastName;
  final String avatar;
  final String? address;
  final String? phoneNumber;

  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.avatar,
      required this.address,
      required this.phoneNumber});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'avatar': avatar,
      'address': address,
      'phoneNumber': phoneNumber
    };
  }
}
