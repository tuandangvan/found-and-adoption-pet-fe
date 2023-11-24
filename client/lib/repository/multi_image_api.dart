import 'dart:convert';
import 'dart:io';

import 'package:found_adoption_application/repository/auth_api.dart';
import 'package:found_adoption_application/models/post.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

Future<List<String>> uploadMultiImage(List<XFile> images) async {
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
    final apiUrl = Uri.parse("http://10.0.2.2:8050/api/v1/upload/multi-image");

    var request = http.MultipartRequest('POST', apiUrl)
      ..headers['Authorization'] = 'Bearer $accessToken';

    for (var image in images) {
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    responseData = json.decode(responseBody);

    if (responseData['message'] == 'jwt expired') {
      //Làm mới accessToken bằng Future<String> refreshAccessToken(), gòi tiếp tục gửi lại request cũ
      var newAccessToken = refreshAccessToken().toString();
      currentClient.accessToken = newAccessToken;

      currentClient == currentUser
          ? userBox.put('currentUser', currentClient)
          : centerBox.put('currentCenter', currentClient);

      var request = http.MultipartRequest('POST', apiUrl)
        ..headers['Authorization'] = 'Bearer $newAccessToken';
      for (var image in images) {
        request.files
            .add(await http.MultipartFile.fromPath('file', image.path));
      }

      var response = await request.send();
      responseBody = await response.stream.bytesToString();
      responseData = json.decode(responseBody);
      print('eeeeeeeee: $responseData');
    }

    print("đường dẫn đến ảnh: ${responseData['images']}");
    // return responseData['images'];

    List<String> urls = responseData['images']
        .map((item) => item['url'].toString())
        .toList()
        .cast<String>();
    print('URLs: $urls');
    return urls;
  } catch (e) {
    print('Error in getAllPost: $e');
    return [];
  }
}
