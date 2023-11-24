class InfoUser {
  final String id;
  final String accountId;
  final String email;
  final String role;
  final bool isActive;
  final String firstName;
  final String lastName;
  final String avatar;
  final String phoneNumber;
  final String address;
  final bool experience;

  const InfoUser({
    required this.id,
    required this.accountId,
    required this.email,
    required this.role,
    required this.isActive,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.phoneNumber,
    required this.address,
    required this.experience,
  });

  // Factory method để tạo đối tượng InfoUser từ JSON
  factory InfoUser.fromJson(Map<String, dynamic> json) {
    return InfoUser(
      id: json['_id'] as String,
      accountId: json['accountId'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      isActive: json['isActive'] ? json['isActive'] : false,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      avatar: json['avatar'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      experience: json['experience'] ? json['experience'] : false,
    );
  }
}
