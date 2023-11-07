// import 'dart:convert';

// import 'package:found_adoption_application/repository/auth_api.dart';
// import 'package:found_adoption_application/models/user_post.dart';
// import 'package:hive/hive.dart';
// import 'package:http/http.dart' as http;

// Future<void> getAllPost() async {
//   var userBox = await Hive.openBox('userBox');
//   var currentUser = userBox.get('currentUser');
//   var accessToken = currentUser.accessToken;

//   final apiUrl = Uri.parse("http://10.0.2.2:8050/api/v1/post");

//   var response = await http.post(apiUrl, headers: {
//     'Authorization': 'Bearer ${accessToken}',
//   });

//   var responseData = json.decode(response.body);
//   print('Response get ALL POST: $responseData');

//   if (responseData['messages'] == 'jwt expired') {
//     //Làm mới accessToken bằng Future<String> refreshAccessToken(), gòi tiếp tục gửi lại request cũ
//     String newAccessToken = refreshAccessToken().toString();
//     currentUser.accessToken = newAccessToken;
//     userBox.put('currentUser', currentUser);

//     response = await http.post(apiUrl, headers: {
//       'Authorization': 'Bearer ${newAccessToken}',
//     });

//     responseData = json.decode(response.body);
//   }

//   var userPostBox = await Hive.openBox('userPostBox'); // Lấy Hive box đã mở
//   var userpost = UserPost()
//     ..id = responseData['data']['_id']
//     ..userId = responseData['data']['accountId']
//     ..createdAt = responseData['data']['email']
//     ..content = responseData['data']['role']
//     ..reaction = responseData['data']['isActive']
//     ..images = responseData['data']['firstName']
//     ..status = responseData['data']['lastName']
//     ..comments = responseData['data']['phoneNumber'];

//   await userPostBox.put('userPost', userpost);
// }

import 'dart:convert';

import 'package:found_adoption_application/repository/auth_api.dart';
import 'package:found_adoption_application/models/user_post.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

Future<void> getAllPost() async {
  var userBox = await Hive.openBox('userBox');
  var currentUser = userBox.get('currentUser');
  var accessToken = currentUser.accessToken;
  try {
    final apiUrl =
        Uri.parse("http://10.0.2.2:8050/api/v1/post/65445509c0d354dc99df83b8");

    var response = await http.post(apiUrl, headers: {
      'Authorization': 'Bearer ${accessToken}',
    });

    var responseData = json.decode(response.body);
    print('Response get ALL POST: $responseData');

    if (responseData['messages'] == 'jwt expired') {
      //Làm mới accessToken bằng Future<String> refreshAccessToken(), gòi tiếp tục gửi lại request cũ
      String newAccessToken = refreshAccessToken().toString();
      currentUser.accessToken = newAccessToken;
      userBox.put('currentUser', currentUser);

      response = await http.post(apiUrl, headers: {
        'Authorization': 'Bearer ${newAccessToken}',
      });

      responseData = json.decode(response.body);
    }

    var userPostBox = await Hive.openBox('userPostBox'); // Lấy Hive box đã mở
    var userpost = UserPost()
      ..id = responseData['data']['_id']
      ..userId = responseData['data']['userId']
      ..createdAt = responseData['data']['createdAt']
      ..content = responseData['data']['content']
      // ..reaction = responseData['data']['reaction']
      ..images = responseData['data']['images'];
    // ..status = responseData['data']['status']
    // ..comments = responseData['data']['comments'];

    await userPostBox.put('userPost', userpost);
  } catch (e) {
    print(e);
  }
}
