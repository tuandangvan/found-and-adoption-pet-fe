import 'dart:convert';
import 'dart:io';

import 'package:found_adoption_application/repository/auth_api.dart';
import 'package:found_adoption_application/models/post.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

Future<String> postComment(String postID, String content) async {
  //mở localstorage nếu currentClient là user
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
  var response;

  try {
    final apiUrl =
        Uri.parse("https://found-and-adoption-pet-api-be.vercel.app/api/v1/post/$postID/comment");

    response = await http.post(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'content': content,
      }),
    );
    responseData = json.decode(response.body);

    if (responseData['message'] == 'jwt expired') {
      //Làm mới accessToken bằng Future<String> refreshAccessToken(), gòi tiếp tục gửi lại request cũ
      var newAccessToken = refreshAccessToken().toString();
      currentClient.accessToken = newAccessToken;

      currentClient == currentUser
          ? userBox.put('currentUser', currentClient)
          : centerBox.put('currentCenter', currentClient);

      response = await http.post(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'content': content,
        }),
      );
      responseData = json.decode(response.body);

    }
    // return responseData['images'];
  } catch (e) {
    print('Error in getAllPost: $e');
  }

  return responseData['_id'];
}
