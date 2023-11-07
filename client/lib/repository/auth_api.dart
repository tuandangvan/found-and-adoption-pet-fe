import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

Future<String> refreshAccessToken() async {
  var userBox = await Hive.openBox('userBox'); // Lấy Hive box đã mở

  final refreshToken = userBox.get('currentUser').refreshToken;
  final apiUrl = Uri.parse("http://10.0.2.2:8050/api/v1/auth/refresh-token");

  final response = await http.post(apiUrl, headers: {
    'Authorization': 'Bearer ${refreshToken}',
    'Content-Type': 'application/json',
  });

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    final newAccessToken = responseData['accessToken'];
    return newAccessToken;
  } else {
    throw Exception('Lỗi làm mới AccessToken');
  }
}
