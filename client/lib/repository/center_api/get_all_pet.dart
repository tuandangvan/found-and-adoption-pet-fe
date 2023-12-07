// import 'dart:convert';
// import 'package:found_adoption_application/models/pet.dart';
// import 'package:found_adoption_application/repository/call_back_api.dart';
// import 'package:found_adoption_application/utils/getCurrentClient.dart';
// import 'package:http/http.dart' as http;

// Future<List<Pet>> getAllPet() async {
//   var currentClient = await getCurrentClient();
//   var accessToken = currentClient.accessToken;
//   var responseData;
//   final apiUrl;

//   try {
//     if(currentClient.role=='USER'){
//      apiUrl = Uri.parse(
//         "https://found-and-adoption-pet-api-be.vercel.app/api/v1/pet/all/pets");
//     }
//     else{
//       apiUrl = Uri.parse(
//         "https://found-and-adoption-pet-api-be.vercel.app/api/v1/pet/${currentClient.id}");
//     }

//     var response = await http.get(apiUrl, headers: {
//       'Authorization': 'Bearer $accessToken',
//     });
//     responseData = json.decode(response.body);
//     // print('Response get ALL POST: $responseData');

//     if (responseData['message'] == 'jwt expired') {
//       responseData = callBackApi(apiUrl, "get", '');
//     }
//   } catch (e) {
//     print('Error in getAllPost: $e');
//   }
//   var petList = responseData['data'] as List<dynamic>;

//   List<Pet> pets = petList.map((json) => Pet.fromJson(json)).toList();
//   return pets;
// }

// Future<List<Pet>> getAllPetOfCenter(centerId) async {
//   var currentClient = await getCurrentClient();
//   var accessToken = currentClient.accessToken;
//   var responseData;

//   try {
//     final apiUrl = Uri.parse(
//         "https://found-and-adoption-pet-api-be.vercel.app/api/v1/pet/${centerId}");

//     var response = await http.get(apiUrl, headers: {
//       'Authorization': 'Bearer $accessToken',
//     });
//     responseData = json.decode(response.body);
//     if (responseData['message'] == 'jwt expired') {
//       responseData = callBackApi(apiUrl, "get", '');
//     }
//   } catch (e) {
//     print('Error in getAllPost: $e');
//   }

//   var petList = responseData['data'] as List<dynamic>;
//   List<Pet> pets = petList.map((json) => Pet.fromJson(json)).toList();
//   return pets;
// }
