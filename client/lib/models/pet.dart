class Pet {
  final String id;
  final String centerId;
  final String namePet;
  final String petType;
  final String breed;
  final String gender;
  final int age;
  final String color;
  final String description;
  List<dynamic> images;
  final String level;

  Pet({
    required this.id,
    required this.centerId,
    required this.namePet,
    required this.petType,
    required this.breed,
    required this.gender,
    required this.age,
    required this.color,
    required this.description,
    required this.images,
    required this.level,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['_id'],
      centerId: json['centerId'],
      namePet: json['namePet'],
      petType: json['petType'],
      breed: json['breed'],
      gender: json['gender'],
      age: json['age'] as int,
      color: json['color'],
      description: json['description'],
      images: json['images'] as List<dynamic>,
      level: json['level'],
    );
  }
}
