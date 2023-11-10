import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/custom_widget/post_card.dart';
import 'package:found_adoption_application/custom_widget/time_countdown.dart';
import 'package:found_adoption_application/models/post.dart';
import 'package:found_adoption_application/models/current_user.dart';
import 'package:found_adoption_application/screens/user_screens/adoption_screen.dart';
import 'package:found_adoption_application/screens/user_screens/animal_detail_screen.dart';
import 'package:found_adoption_application/screens/user_screens/edit_profile_screen.dart';
import 'package:found_adoption_application/screens/user_screens/feed_screen.dart';
import 'package:found_adoption_application/screens/user_screens/login_screen.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame.dart';
import 'package:found_adoption_application/screens/user_screens/menu_screen.dart';
import 'package:found_adoption_application/screens/user_screens/test.dart';

import 'package:found_adoption_application/screens/user_screens/welcome_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());

  runApp(MyApp());
}

Color mainColor = const Color.fromRGBO(48, 96, 96, 1.0);
Color startingColor = const Color.fromRGBO(70, 112, 112, 1.0);

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primaryColor: mainColor,
//       ),
//       home: EditProfileScreen(),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  // Đặt biến hasValidRefreshToken là một Future<bool>
  Future<bool> hasValidRefreshToken = checkRefreshToken();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: hasValidRefreshToken,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final refreshTokenIsValid = snapshot.data;
          if (refreshTokenIsValid != null) {
            return MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: mainColor,
              ),
              home: refreshTokenIsValid ? MenuFrame() : WelcomeScreen(),
            );
          } else {
            // Xử lý trường hợp biến là null
            return CircularProgressIndicator();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

Future<bool> checkRefreshToken() async {
  try {
    final userBox = await Hive.openBox('userBox');
    final currentUser = userBox.get('currentUser');
    final refreshTokenTimestamp = userBox.get('refreshTokenTimestamp');
    const refreshTokenValidityDays = 7;
    final DateTime now = DateTime.now();

    if (currentUser != null) {
      final expirationTime = refreshTokenTimestamp.add(
        Duration(days: refreshTokenValidityDays),
      );
      print('The current user is Logged in at: ${refreshTokenTimestamp}');
      print('The RefreshToken is expired at: ${expirationTime}');
      if (now.isBefore(expirationTime)) {
        return true;
      }
    }
    return false;
  } catch (e) {
    print(e);
    return false;
  }
}
