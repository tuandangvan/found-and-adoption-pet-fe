import 'dart:convert';

import 'package:found_adoption_application/repository/auth_api.dart';
import 'package:found_adoption_application/models/post.dart';
import 'package:found_adoption_application/repository/call_back_api.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

Future<List<Post>> getAllPost() async {
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

  try {
    final apiUrl = Uri.parse(
        "https://found-and-adoption-pet-api-be.vercel.app/api/v1/post");

    var response = await http.get(apiUrl, headers: {
      'Authorization': 'Bearer $accessToken',
    });
    responseData = json.decode(response.body);
    // print('Response get ALL POST: $responseData');

    if (responseData['message'] == 'jwt expired') {
      //Làm mới accessToken bằng Future<String> refreshAccessToken(), gòi tiếp tục gửi lại request cũ
      var newAccessToken = refreshAccessToken().toString();

      currentClient.accessToken = newAccessToken;
      // userBox.put('currentUser', currentClient); //??????????

      currentClient == currentUser
          ? userBox.put('currentUser', currentClient)
          : centerBox.put('currentCenter', currentClient);

      response = await http.post(apiUrl, headers: {
        'Authorization': 'Bearer $newAccessToken',
      });

      responseData = json.decode(response.body);
      print(responseData);
    }
  } catch (e) {
    print('Error in getAllPost: $e');
  }

  // print('All Post display here: ${responseData['data']}');

  // print(responseData);

  var postList = responseData['data'] as List<dynamic>;

  List<Post> posts = postList.map((json) => Post.fromJson(json)).toList();

  return posts;
}

Future<String> changeStatusPost(String postId, String status) async {
  var currentClient = await getCurrentClient();
  var accessToken = currentClient.accessToken;
  var responseData;
  var message = '';
  var body = jsonEncode(<String, String>{'status': status});
  print(body);

  try {
    final apiUrl = Uri.parse(
        "https://found-and-adoption-pet-api-be.vercel.app/api/v1/post/$postId/status");

    var response = await http.put(apiUrl,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: body);
    responseData = json.decode(response.body);
    if (responseData['message'] == 'jwt expired') {
      responseData = callBackApi(apiUrl, "put", body);
    }

    if (responseData['error'] != null) {
      message = responseData['error'];
    } else {
      message = responseData['message'];
    }
  } catch (err) {}

  return message;
}

Future<List<Post>> getAllPostPersonal(var id) async {
  var currentClient = await getCurrentClient();
  var accessToken = currentClient.accessToken;
  var responseData;

  try {
    final apiUrl = Uri.parse(
        "https://found-and-adoption-pet-api-be.vercel.app/api/v1/post/personal/${id}");

    var response = await http.get(apiUrl, headers: {
      'Authorization': 'Bearer $accessToken',
    });
    responseData = json.decode(response.body);
    // print('Response get ALL POST: $responseData');

    if (responseData['message'] == 'jwt expired') {
      responseData = callBackApi(apiUrl, "get", '');
    }
  } catch (e) {
    print('Error in getAllPost: $e');
  }
  var postList = responseData['data'] as List<dynamic>;

  List<Post> posts = postList.map((json) => Post.fromJson(json)).toList();

  return posts;
}
