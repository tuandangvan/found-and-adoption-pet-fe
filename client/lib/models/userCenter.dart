class InfoCenter {
  final String id;
  final String accountId;
  final String email;
  final String role;
  final bool isActive;
  final String name;
  final String avatar;
  final String phoneNumber;
  final String address;

  const InfoCenter({
    required this.id,
    required this.accountId,
    required this.email,
    required this.role,
    required this.isActive,
    required this.name,
    required this.avatar,
    required this.phoneNumber,
    required this.address,
  });

  // Factory method để tạo đối tượng InfoUser từ JSON
  factory InfoCenter.fromJson(Map<String, dynamic> json) {
    return InfoCenter(
      id: json['_id'] as String, 
      accountId: json['accountId'] as String,  
      email: json['email'] as String,
      role: json['role'] as String,
      isActive: json['isActive']? json['isActive']:false,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
    );
  }
}
