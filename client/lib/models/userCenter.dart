class InfoCenter {
  final String id;
  final String accountId;
  final String email;
  final String role;
  final String status;
  final String name;
  final String avatar;
  final String phoneNumber;
  final String address;
  final String aboutMe;
  final String? createdAt;
  final String? updatedAt;

  const InfoCenter({
    required this.id,
    required this.accountId,
    required this.email,
    required this.role,
    required this.status,
    required this.name,
    required this.avatar,
    required this.phoneNumber,
    required this.address,
    required this.aboutMe,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method để tạo đối tượng InfoUser từ JSON
  factory InfoCenter.fromJson(Map<String, dynamic> json) {
    return InfoCenter(
      id: json['_id'] as String,
      accountId: json['accountId'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      aboutMe: json['aboutMe'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }
}
