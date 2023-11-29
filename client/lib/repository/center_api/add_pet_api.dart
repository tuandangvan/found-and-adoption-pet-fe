import 'dart:convert';

import 'package:found_adoption_application/repository/auth_api.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

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
  var userBox = await Hive.openBox('userBox');
  var currentUser = userBox.get('currentUser');

  //mở localstorage nếu currentClient là center
  var centerBox = await Hive.openBox('centerBox');
  var currentCenter = centerBox.get('currentCenter');

  // Sử dụng dữ liệu của người dùng hiện tại dựa trên tình huống cụ thể
  var currentClient = currentUser != null && currentUser.role == 'USER'
      ? currentUser
      : currentCenter;

  //bắt đầu từ đoạn này, cẩn phải thay đổi currentClient là currentUser hay currentCenter cho phù hợp
  var accessToken = currentClient.accessToken;

  var responseData = {};

  try {
    final apiUrl = Uri.parse(
        "https://found-and-adoption-pet-api-be.vercel.app/api/v1/pet");

    var response = await http.post(
      apiUrl,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "namePet": namePet,
        "petType": petType,
        "breed": breed,
        "age": age,
        "gender": gender,
        "color": color,
        "images": imagePaths,
        "description": description,
        "level": level
      }),
    );

    responseData = json.decode(response.body);

    if (responseData['message'] == 'jwt expired') {
      var newAccessToken = refreshAccessToken().toString();

      currentClient.accessToken = newAccessToken;
      // userBox.put('currentUser', currentClient); //??????????

      currentClient == currentUser
          ? userBox.put('currentUser', currentClient)
          : centerBox.put('currentCenter', currentClient);

      response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "namePet": namePet,
          "petType": petType,
          "breed": breed,
          "age": age,
          "gender": gender,
          "color": color,
          "images": imagePaths,
          "description": description,
          "level": level
        }),
      );

      responseData = json.decode(response.body);
      print(responseData);
    }

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      print('Post bài viết thành công: $responseData');
    } else {
      print('Post fail: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print(e);
  }
}
