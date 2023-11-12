// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:found_adoption_application/models/current_user.dart';
// import 'package:found_adoption_application/screens/user_screens/menu_frame.dart';
// import 'package:hive/hive.dart';

// import 'package:http/http.dart' as http;

// Future<void> login(BuildContext context, String email, String password) async {
//   try {
//     final apiUrl = Uri.parse("http://10.0.2.2:8050/api/v1/auth/sign-in");

//     final response = await http.post(
//       apiUrl,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode(<String, String>{
//         'email': email,
//         'password': password,
//       }),
//     );

//     if (response.statusCode == 200) {
//       // Đăng nhập thành công, xử lý dữ liệu phản hồi (response.body) ở đây
//       final responseData = json.decode(response.body);
//       print('Đăng nhập thành công: $responseData');

//       var userBox = await Hive.openBox('userBox'); // Lấy Hive box đã mở
//       var user = User()
//         ..id = responseData['data']['_id']
//         ..accountId = responseData['data']['accountId']
//         ..email = responseData['data']['email']
//         ..role = responseData['data']['role']
//         ..isActive = responseData['data']['isActive']
//         ..firstName = responseData['data']['firstName']
//         ..lastName = responseData['data']['lastName']
//         ..phoneNumber = responseData['data']['phoneNumber']
//         ..address = responseData['data']['address']
//         ..refreshToken = responseData['data']['refreshToken']
//         ..accessToken = responseData['data']['accessToken'];

//       await userBox.put('currentUser', user);
//       await userBox.put('refreshTokenTimestamp', DateTime.now());

//       var retrievedUser =
//           userBox.get('currentUser'); // Lấy thông tin User từ Hive

//       // Sử dụng thông tin User
//       print('User ID: ${retrievedUser.id}');
//       print('Email: ${retrievedUser.email}');

//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => MenuFrame()));
//     } else {
//       print('Lỗi khi đăng nhập, mã trạng thái: ${response.statusCode}');
//     }
//   } catch (e) {
//     print(e);
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/current_center.dart';
import 'package:found_adoption_application/models/current_user.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;

Future<void> login(
  BuildContext context,
  String email,
  String password,
) async {
  try {
    final apiUrl = Uri.parse("http://10.0.2.2:8050/api/v1/auth/sign-in");

    final response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Đăng nhập thành công: $responseData');

      // Tạo đối tượng người dùng tương ứng dựa trên loại người dùng

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
          ..address = responseData['data']['address']
          ..refreshToken = responseData['data']['refreshToken']
          ..accessToken = responseData['data']['accessToken'];

        await userBox.put('currentUser', user);
        await userBox.put('refreshTokenTimestamp', DateTime.now());

        var retrievedUser =
            userBox.get('currentUser'); // Lấy thông tin User từ Hive

        // Sử dụng thông tin User
        print('User ID: ${retrievedUser.id}');
        print('Email: ${retrievedUser.email}');

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MenuFrame()));
      }

      //Nếu response trả về là Center
      else if (responseData['data']['role'] == 'CENTER') {
        var centerBox = await Hive.openBox('centerBox'); // Lấy Hive box đã mở
        var currentCenter = CurrentCenter()
          ..id = responseData['data']['_id']
          ..accountId = responseData['data']['accountId']
          ..email = responseData['data']['email']
          ..role = responseData['data']['role']
          ..isActive = responseData['data']['isActive']
          ..name = responseData['data']['name']
          ..phoneNumber = responseData['data']['phoneNumber']
          ..address = responseData['data']['address']
          ..refreshToken = responseData['data']['refreshToken']
          ..accessToken = responseData['data']['accessToken'];

        await centerBox.put('currentCenter', currentCenter);
        await centerBox.put('refreshTokenTimestamp', DateTime.now());

        var retrievedCenter =
            centerBox.get('currentCenter'); // Lấy thông tin User từ Hive

        // Sử dụng thông tin User
        print('Center ID: ${retrievedCenter.id}');
        print('Email: ${retrievedCenter.email}');

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MenuFrame()));
      }
    } else {
      print('Lỗi khi đăng nhập, mã trạng thái: ${response.statusCode}');
    }
  } catch (e) {
    print(e);
  }
}
