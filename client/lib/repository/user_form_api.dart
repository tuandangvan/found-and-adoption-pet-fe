import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/welcome_screen.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

Future<void> userform(BuildContext context, String firstName, String lastName,
    String phoneNumber, String address, bool experience) async {
  final accountRegisterBox = await Hive.openBox('accountRegisterBox');
  final storedAccount = accountRegisterBox.get('account');
  print(storedAccount);
  try {
    final apiUrl = Uri.parse(
        "https://found-and-adoption-pet-api-be.vercel.app/api/v1/user/${storedAccount}");
    print('đường dẫn là : ${apiUrl}');

    final response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'address': address,
        'experience': experience
      }),
    );

    if (response.statusCode == 201) {
      print('Filled success');

      final responseData = json.decode(response.body);
      print('Đăng ký thành công: $responseData');

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
    } else {
      print(response.body);
      print("Fill User's information FAIL");
    }
  } catch (e) {
    print(e);
  }
}
