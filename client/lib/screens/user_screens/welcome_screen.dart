import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:found_adoption_application/custom_widget/dialog_otp.dart';
import 'package:found_adoption_application/main.dart';
import 'package:found_adoption_application/screens/user_screens/login_screen.dart';
import 'package:found_adoption_application/screens/user_screens/signUp_screen.dart';
import 'package:found_adoption_application/custom_widget/banner_card_widget.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Center(
                    child: Container(
                        height: 470,
                        alignment: Alignment.bottomCenter,
                        child: bannerCard()),
                  ),
                  Center(child: _imgBanner()),
                ],
              ),
              SizedBox(height: 30),
              Column(children: [
                // the login button
                MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  // defining the shape
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
                // creating the signup button
                SizedBox(height: 20),
                MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen()));
                  },
                  color: startingColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }

  Widget _imgBanner() {
    return Container(
      height: 350,
      child: Image(
        image: AssetImage('assets/images/dog_banner.png'),
      ),
    );
  }
}
