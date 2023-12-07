import 'dart:convert';
import 'package:found_adoption_application/services/auth_api.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

Future<List<String>> uploadMultiImage(List<XFile> images) async {
  var userBox = await Hive.openBox('userBox');
  var currentUser = userBox.get('currentUser');
  var centerBox = await Hive.openBox('centerBox');
  var currentCenter = centerBox.get('currentCenter');
  var currentClient = currentUser != null && currentUser.role == 'USER'
      ? currentUser
      : currentCenter;
  var accessToken = currentClient.accessToken;

  var responseData = {};

  try {
    final apiUrl = Uri.parse("https://found-and-adoption-pet-api-be.vercel.app/api/v1/upload/multi-image");

    var request = http.MultipartRequest('POST', apiUrl)
      ..headers['Authorization'] = 'Bearer $accessToken';

    for (var image in images) {
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    responseData = json.decode(responseBody);

    if (responseData['message'] == 'jwt expired') {
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
    }
    List<String> urls = responseData['images']
        .map((item) => item['url'].toString())
        .toList()
        .cast<String>();
    return urls;
  } catch (e) {
    // notification(e.toString(), true);
    return [];
  }
}
