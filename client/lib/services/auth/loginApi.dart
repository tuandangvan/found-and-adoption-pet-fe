import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/current_center.dart';
import 'package:found_adoption_application/models/current_user.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

Future<void> login(
  BuildContext context,
  String email,
  String password,
) async {
  var responseData;
  var body = jsonEncode(<String, String>{'email': email, 'password': password});
  try {
    final apiUrl = Uri.parse(
        "https://found-and-adoption-pet-api-be.vercel.app/api/v1/auth/sign-in");
    var response = await http.post(apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body);

    responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      if (responseData['data']['role'] == 'USER') {
        var userBox = await Hive.openBox('userBox'); // Lấy Hive box đã mở
        var user = User()
          ..id = responseData['data']['_id']
          ..accountId = responseData['data']['accountId']
          ..email = responseData['data']['email']
          ..role = responseData['data']['role']
          ..isActive = responseData['data']['isActive']
          ..firstName = responseData['data']['firstName']
          ..lastName = responseData['data']['lastName']
          ..phoneNumber = responseData['data']['phoneNumber']
          ..avatar = responseData['data']['avatar']
          ..address = responseData['data']['address']
          ..refreshToken = responseData['data']['refreshToken']
          ..accessToken = responseData['data']['accessToken'];

        await userBox.put('currentUser', user);
        await userBox.put('refreshTokenTimestamp', DateTime.now());

        var retrievedUser =
            userBox.get('currentUser'); // Lấy thông tin User từ Hive
        notification("Login user success!", false);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MenuFrameUser(
                      userId: retrievedUser.id,
                    )));
      } else if (responseData['data']['role'] == 'CENTER') {
        var centerBox = await Hive.openBox('centerBox'); // Lấy Hive box đã mở
        var currentCenter = CurrentCenter()
          ..id = responseData['data']['_id']
          ..accountId = responseData['data']['accountId']
          ..email = responseData['data']['email']
          ..role = responseData['data']['role']
          ..isActive = responseData['data']['isActive']
          ..name = responseData['data']['name']
          ..avatar = responseData['data']['avatar']
          ..phoneNumber = responseData['data']['phoneNumber']
          ..address = responseData['data']['address']
          ..refreshToken = responseData['data']['refreshToken']
          ..accessToken = responseData['data']['accessToken'];

        await centerBox.put('currentCenter', currentCenter);
        await centerBox.put('refreshTokenTimestamp', DateTime.now());

        var retrievedCenter =
            centerBox.get('currentCenter'); // Lấy thông tin User từ Hive
        notification("Login center success!", false);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MenuFrameCenter(centerId: retrievedCenter.id)));
      }
    } else {
      notification(responseData['message'], true);
      print(responseData);
    }
  } catch (e) {
    print(e);
    // notification(e.toString(), true);
  }
}
