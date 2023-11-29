class Pet {
  final String namePet;
  final String petType;
  final String breed;
  final double age;
  final String gender;
  final String color;
  List<dynamic>? images;
  final String description;
  final String level;

  Pet({
    required this.namePet,
    required this.petType,
    required this.breed,
    required this.age,
    required this.gender,
    required this.color,
    required this.images,
    required this.description,
    required this.level,
  });
}
