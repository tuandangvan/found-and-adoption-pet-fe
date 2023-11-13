import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:found_adoption_application/repository/auth_api.dart';

Future<dynamic> callBackApi(apiUrl, method, body) async {
  var userBox = await Hive.openBox('userBox');
  var currentUser = userBox.get('currentUser');
  var newAccessToken = refreshAccessToken().toString();
  currentUser.accessToken = newAccessToken;
  userBox.put('currentUser', currentUser);
  var response;
  if (method == "post") {
    response = await http.post(apiUrl,
        headers: {
          'Authorization': 'Bearer $newAccessToken',
          'Content-Type': 'application/json',
        },
        body: body);
  } else if (method == "put") {
    response = await http.put(apiUrl,
        headers: {
          'Authorization': 'Bearer $newAccessToken',
          'Content-Type': 'application/json',
        },
        body: body);
  } else if (method == "get") {
    response = await http.get(apiUrl, headers: {
      'Authorization': 'Bearer $newAccessToken',
      'Content-Type': 'application/json',
    });
  }
  return json.decode(response.body);
}
