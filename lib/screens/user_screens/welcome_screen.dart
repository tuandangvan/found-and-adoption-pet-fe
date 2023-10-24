import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                  color: Color(0xff0095FF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    "Sign up",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }

  // Widget _bannerCard() => Container(
  //       height: 250,
  //       width: 340,
  //       child: Card(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(40),
  //         ),
  //         elevation: 10,
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             Text(
  //               'Welcome',
  //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
  //             ),
  //             SizedBox(height: 20),
  //             Container(
  //               padding: const EdgeInsets.symmetric(horizontal: 18),
  //               child: Text(
  //                 'Find the best pet near you and adopt your favorite one',
  //                 style: TextStyle(
  //                   fontWeight: FontWeight.w600,
  //                   fontSize: 16,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //             ),
  //             SizedBox(height: 58),
  //           ],
  //         ),
  //       ),
  //     );

  Widget _imgBanner() {
    return Container(
      height: 350,
      child: Image(
        image: AssetImage('assets/images/dog_banner.png'),
      ),
    );
  }
}
