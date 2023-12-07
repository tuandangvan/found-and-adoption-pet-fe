class PetCenter {
  final String id;
  final String name;
  final String avatar;
  final String address;
  final String phoneNumber;

  PetCenter({
    required this.id,
    required this.name,
    required this.avatar,
    required this.address,
    required this.phoneNumber
  });
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'avatar': avatar,
      'address': address,
      'phoneNumber': phoneNumber
    };
  }
}
