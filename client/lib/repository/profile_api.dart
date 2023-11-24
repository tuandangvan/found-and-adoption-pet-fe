import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/userInfo.dart';
import 'package:found_adoption_application/repository/call_back_api.dart';
// import 'package:found_adoption_application/models/current_user.dart';
// import 'package:found_adoption_application/screens/user_screens/menu_frame.dart';
import 'package:hive/hive.dart';
import 'package:found_adoption_application/repository/auth_api.dart';

import 'package:http/http.dart' as http;

Future<InfoUser> getProfile(BuildContext context) async {
  var userBox = await Hive.openBox('userBox');
  var currentUser = userBox.get('currentUser');
  var userId = currentUser.id;
  var accessToken = currentUser.accessToken;
  var user;
  try {
    var responseData;
    final apiUrl = Uri.parse("http://10.0.2.2:8050/api/v1/user/${userId}");

    var response = await http.get(apiUrl, headers: {
      'Authorization': 'Bearer ${accessToken}',
    });
    responseData = json.decode(response.body);
    // print('Response get ALL POST: $responseData');

    if (responseData['message'] == 'jwt expired') {
      //Làm mới accessToken bằng Future<String> refreshAccessToken(), gòi tiếp tục gửi lại request cũ
      var newAccessToken = refreshAccessToken().toString();
      print('Token mới: $newAccessToken');
      currentUser.accessToken = newAccessToken;
      userBox.put('currentUser', currentUser);

      response = await http.post(apiUrl, headers: {
        'Authorization': 'Bearer $newAccessToken',
      });

      responseData = json.decode(response.body);
    }
    var userData = responseData['user'];
    user = InfoUser.fromJson(userData);
  } catch (e) {
    print(e);
  }
  return user;
}

Future<void> updateProfile(
    BuildContext context, firstName, lastName, phoneNumber, address) async {
  var userBox = await Hive.openBox('userBox');
  var currentUser = userBox.get('currentUser');
  var userId = currentUser.id;
  var accessToken = currentUser.accessToken;
  try {
    var responseData;
    final apiUrl = Uri.parse("http://10.0.2.2:8050/api/v1/user/${userId}");
    var body = jsonEncode(<String, String>{
      if (firstName != "") 'firstName': firstName,
      if (lastName != "") 'lastName': lastName,
      if (phoneNumber != "") 'phoneNumber': phoneNumber,
      if (address != "") 'address': address
    });

    var response = await http.put(apiUrl,
        headers: {
          'Authorization': 'Bearer ${accessToken}',
          'Content-Type': 'application/json',
        },
        body: body);
    responseData = json.decode(response.body);

    if (responseData['message'] == 'jwt expired') {
      responseData = await callBackApi(apiUrl, "put", body);
    }
  } catch (e) {
    print(e);
  }
}
