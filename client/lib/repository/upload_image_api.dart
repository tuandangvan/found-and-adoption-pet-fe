// import 'dart:convert';
// import 'dart:io';

// import 'package:found_adoption_application/repository/auth_api.dart';
// import 'package:hive/hive.dart';
// import 'package:http/http.dart' as http;

// Future<String> uploadImage(File image) async {
//   //mở localstorage nếu currentClient là user
//   var userBox = await Hive.openBox('userBox');
//   var currentUser = userBox.get('currentUser');

//   //mở localstorage nếu currentClient là center
//   var centerBox = await Hive.openBox('centerBox');
//   var currentCenter = centerBox.get('currentCenter');

//   // Sử dụng dữ liệu của người dùng hiện tại dựa trên tình huống cụ thể
//   var currentClient = currentUser != null && currentUser.role == 'USER'
//       ? currentUser
//       : currentCenter;

//   //bắt đầu từ đoạn này, cẩn phải thay đổi currentClient là currentUser hay currentCenter cho phù hợp
//   var accessToken = currentClient.accessToken;

//   var responseData = {};

//   try {
//     final apiUrl = Uri.parse("https://found-and-adoption-pet-api-be.vercel.app/api/v1/upload/single");

//     var request = http.MultipartRequest('POST', apiUrl)
//       ..headers['Authorization'] = 'Bearer $accessToken'
//       ..files.add(await http.MultipartFile.fromPath('file', image.path));

//     var response = await request.send();
//     var responseBody = await response.stream.bytesToString();
//     responseData = json.decode(responseBody);
//     print("ddddddd: ${responseData['url']}");

//     if (responseData['message'] == 'jwt expired') {
//       //Làm mới accessToken bằng Future<String> refreshAccessToken(), gòi tiếp tục gửi lại request cũ
//       var newAccessToken = refreshAccessToken().toString();
//       currentClient.accessToken = newAccessToken;

//       currentClient == currentUser
//           ? userBox.put('currentUser', currentClient)
//           : centerBox.put('currentCenter', currentClient);

//       var request = http.MultipartRequest('POST', apiUrl)
//         ..headers['Authorization'] = 'Bearer $newAccessToken'
//         ..files.add(await http.MultipartFile.fromPath('file', image.path));

//       var response = await request.send();
//       responseBody = await response.stream.bytesToString();
//       responseData = json.decode(responseBody);
//       print('eeeeeeeee: $responseData');
//       return responseData['url'];
//     }

//     print("đường dẫn đến ảnh: ${responseData['url']}");
//     return responseData['url'];
//   } catch (e) {
//     print('Error in getAllPost: $e');
//     return '';
//   }
// }
