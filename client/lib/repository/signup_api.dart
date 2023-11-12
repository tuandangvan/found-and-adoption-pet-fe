import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:found_adoption_application/custom_widget/dialog_otp.dart';
import 'package:found_adoption_application/screens/user_screens/registration_form.dart';
import 'package:found_adoption_application/screens/user_screens/signUp_screen.dart';
import 'package:found_adoption_application/screens/user_screens/welcome_screen.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

Future<void> signup(BuildContext context, String email, String password,
    String signupType) async {
  try {
    final apiUrl = Uri.parse("http://10.0.2.2:8050/api/v1/auth/sign-up");

    final response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'role': signupType, // Lựa chọn từ radio button
      }),
    );

    if (response.statusCode == 201) {
      // Xử lý thành công
      final responseData = json.decode(response.body);
      print('Indentify Account after register :${responseData['account']}');

      final accountRegisterBox = await Hive.openBox('accountRegisterBox');
      accountRegisterBox.put('account', responseData['account']);

      print('Đăng ký thành công: $responseData');

      showOTPInputDialog(context);
    } else {
      // Xử lý lỗi
      print('Lỗi khi đăng ký, mã trạng thái: ${response.statusCode}');
      print(response.body);
    }
  } catch (e) {
    print(e);
  }
}


Future<bool> verifycode(String email, String code) async {
  try {
    final apiUrl = Uri.parse("http://10.0.2.2:8050/api/v1/auth/verify-code");

    final response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'code': code,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Xác thực OTP thành công: $responseData');

      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => RegistrationForm()));
      return true;
    } else {
      print('Lỗi xác thực OTP, mã trạng thái: ${response.statusCode}');
      print(response.body);
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}

Future<void> resendcode(String email) async {
  try {
    final apiUrl = Uri.parse('http://10.0.2.2:8050/api/v1/auth/send-code');

    final response = await http.post(apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email}));

    if (response.statusCode == 200) {
      print('RESEND SUCCESS !');

      final responseData = jsonDecode(response.body);
      print('Resend success: ${responseData}');
    } else {
      print('RESEND FAIL');
    }
  } catch (e) {
    print(e);
  }
}
