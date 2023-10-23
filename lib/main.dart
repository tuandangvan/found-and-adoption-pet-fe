import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/screens/user_screens/adoption_screen.dart';
import 'package:found_adoption_application/screens/user_screens/animal_detail_screen.dart';
import 'package:found_adoption_application/screens/user_screens/login_screen.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame.dart';
import 'package:found_adoption_application/screens/user_screens/menu_screen.dart';

import 'package:found_adoption_application/screens/user_screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

Color mainColor = const Color.fromRGBO(48, 96, 96, 1.0);
Color startingColor = const Color.fromRGBO(70, 112, 112, 1.0);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: mainColor,
      ),
      home: WelcomeScreen(),
    );
  }
}
