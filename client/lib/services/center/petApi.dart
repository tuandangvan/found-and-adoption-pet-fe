import 'dart:convert';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/services/api.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';

Future<void> addPet(
  String namePet,
  String petType,
  String breed,
  double age,
  String gender,
  String color,
  List<dynamic> imagePaths,
  String description,
  String level,
) async {
  var responseData = {};
  var body = jsonEncode({
    "namePet": namePet,
    "petType": petType,
    "breed": breed,
    "age": age,
    "gender": gender,
    "color": color,
    "images": imagePaths,
    "description": description,
    "level": level
  });

  try {
    responseData = await api('/pet', 'POST', body);

    if (responseData['success']) {
      notification(responseData['message'], false);
    } else {
      notification(responseData['message'], true);
    }
  } catch (e) {
    print(e);
  //  notification(e.toString(), true);
  }
}

Future<List<Pet>> getAllPet() async {
  var currentClient = await getCurrentClient();
  var responseData;
  final apiUrl;

  try {
    if (currentClient.role == 'USER') {
      apiUrl = "/pet/all/pets";
    } else {
      apiUrl = "/pet/${currentClient.id}";
    }
    responseData = await api(apiUrl, "GET", '');
  } catch (e) {
    print(e);
  //  notification(e.toString(), true);
  }
  var petList = responseData['data'] as List<dynamic>;
  List<Pet> pets = petList.map((json) => Pet.fromJson(json)).toList();
  return pets;
}

Future<List<Pet>> getAllPetOfCenter(centerId) async {
  var responseData;
  try {
    final apiUrl = "/pet/${centerId}";
    responseData = await api(apiUrl, "GET", '');
  } catch (e) {
    print(e);
  //  notification(e.toString(), true);
  }
  var petList = responseData['data'] as List<dynamic>;
  List<Pet> pets = petList.map((json) => Pet.fromJson(json)).toList();
  return pets;
}
