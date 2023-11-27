class User {
  final String id;
  final String firstName;
  final String lastName;
  final String avatar;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'avatar': avatar,
    };
  }
}
