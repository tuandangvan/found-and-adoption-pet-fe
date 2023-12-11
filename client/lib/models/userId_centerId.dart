class UserId_CenterId {
  final String id;
  final String? centerId;
  final String? userId;

  UserId_CenterId({
    required this.id,
    required this.userId,
    required this.centerId,
  });

  factory UserId_CenterId.fromJson(Map<String, dynamic> json) {
    return UserId_CenterId(
      id: json['_id'],
      userId: json['userId'],
      centerId: json['centerId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'userId': userId,
      'centerId': centerId,
    };
  }
}
