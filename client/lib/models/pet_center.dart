class PetCenter {
  final String id;
  final String name;

  final String avatar;

  PetCenter({
    required this.id,
    required this.name,
    required this.avatar,
  });
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'avatar': avatar,
    };
  }
}
