import 'dart:convert';

import 'package:found_adoption_application/repository/auth_api.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

Future<bool> addPet(String content, List<dynamic> imagePaths) async {
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
        "content": content,
        "images": imagePaths,
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
          "content": content,
          "images": imagePaths,
        }),
      );

      responseData = json.decode(response.body);
      print(responseData);
    }

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      print('Post bài viết thành công: $responseData');

      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => RegistrationForm()));
      return true;
    } else {
      print('Post fail: ${response.statusCode}');
      print(response.body);
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}
