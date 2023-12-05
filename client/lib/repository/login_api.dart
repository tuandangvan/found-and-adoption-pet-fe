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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:found_adoption_application/models/current_center.dart';
import 'package:found_adoption_application/models/current_user.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;

Future<void> login(
  BuildContext context,
  String email,
  String password,
) async {
  var message = '';
  try {
    final apiUrl = Uri.parse(
        "https://found-and-adoption-pet-api-be.vercel.app/api/v1/auth/sign-in");

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
    message = json.decode(response.body)['message'] ?? '';

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
          ..avatar = responseData['data']['avatar']
          ..address = responseData['data']['address']
          ..refreshToken = responseData['data']['refreshToken']
          ..accessToken = responseData['data']['accessToken'];

        await userBox.put('currentUser', user);
        await userBox.put('refreshTokenTimestamp', DateTime.now());

        var retrievedUser =
            userBox.get('currentUser'); // Lấy thông tin User từ Hive

        Fluttertoast.showToast(
          msg: 'Login success',
          toastLength: Toast.LENGTH_SHORT, // Thời gian hiển thị
          gravity: ToastGravity.BOTTOM, // Vị trí hiển thị
          timeInSecForIosWeb: 1, // Thời gian hiển thị cho iOS và web
          backgroundColor: Colors.grey, // Màu nền của toast
          textColor: Colors.white, // Màu chữ của toast
          fontSize: 16.0, // Kích thước chữ của toast
        );
        // Sử dụng thông tin User
        print('User ID: ${retrievedUser.id}');
        print('Email: ${retrievedUser.email}');

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MenuFrameUser(
                      userId: retrievedUser.id,
                    )));
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
          ..avatar = responseData['data']['avatar']
          ..phoneNumber = responseData['data']['phoneNumber']
          ..address = responseData['data']['address']
          ..refreshToken = responseData['data']['refreshToken']
          ..accessToken = responseData['data']['accessToken'];

        await centerBox.put('currentCenter', currentCenter);
        await centerBox.put('refreshTokenTimestamp', DateTime.now());

        var retrievedCenter =
            centerBox.get('currentCenter'); // Lấy thông tin User từ Hive
        Fluttertoast.showToast(
          msg: 'Login success',
          toastLength: Toast.LENGTH_SHORT, // Thời gian hiển thị
          gravity: ToastGravity.BOTTOM, // Vị trí hiển thị
          timeInSecForIosWeb: 1, // Thời gian hiển thị cho iOS và web
          backgroundColor: Colors.grey, // Màu nền của toast
          textColor: Colors.white, // Màu chữ của toast
          fontSize: 16.0, // Kích thước chữ của toast
        );
        // Sử dụng thông tin User
        print('Center ID: ${retrievedCenter.id}');
        print('Email: ${retrievedCenter.email}');

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MenuFrameCenter(centerId: retrievedCenter.id)));
      }
    } else {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT, // Thời gian hiển thị
        gravity: ToastGravity.BOTTOM, // Vị trí hiển thị
        timeInSecForIosWeb: 1, // Thời gian hiển thị cho iOS và web
        backgroundColor: Colors.grey, // Màu nền của toast
        textColor: Colors.white, // Màu chữ của toast
        fontSize: 16.0, // Kích thước chữ của toast
      );
      print('Lỗi khi đăng nhập, mã trạng thái: ${response.statusCode}');
    }
  } catch (e) {
    print(e);
    Fluttertoast.showToast(
      msg: e.toString(),
      toastLength: Toast.LENGTH_SHORT, // Thời gian hiển thị
      gravity: ToastGravity.BOTTOM, // Vị trí hiển thị
      timeInSecForIosWeb: 1, // Thời gian hiển thị cho iOS và web
      backgroundColor: Colors.grey, // Màu nền của toast
      textColor: Colors.white, // Màu chữ của toast
      fontSize: 16.0, // Kích thước chữ của toast
    );
  }
}
