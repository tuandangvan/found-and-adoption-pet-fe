// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:found_adoption_application/screens/user_screens/login_screen.dart';
// import 'package:found_adoption_application/screens/user_screens/signUp_screen.dart';

// class WelcomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           // we will give media query height
//           // double.infinity make it big as my parent allows
//           // while MediaQuery make it big as per the screen

//           width: double.infinity,
//           height: MediaQuery.of(context).size.height,
//           padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
//           child: Column(
//             // even space distribution
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Column(
//                 children: <Widget>[
//                   Text(
//                     "Welcome",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 30,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Text(
//                     "BackSlash Flutter provides extraordinary flutter tutorials. Do Subscribe! ",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.grey[700],
//                       fontSize: 15,
//                     ),
//                   )
//                 ],
//               ),
//               Container(
//                 height: MediaQuery.of(context).size.height / 3,
//                 decoration: BoxDecoration(
//                     image: DecorationImage(
//                         image: AssetImage("assets/images/dog_banner.png"))),
//               ),
//               Column(
//                 children: <Widget>[
//                   // the login button
//                   MaterialButton(
//                     minWidth: double.infinity,
//                     height: 60,
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => LoginScreen()));
//                     },
//                     // defining the shape
//                     shape: RoundedRectangleBorder(
//                         side: BorderSide(color: Colors.black),
//                         borderRadius: BorderRadius.circular(50)),
//                     child: Text(
//                       "Login",
//                       style:
//                           TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
//                     ),
//                   ),
//                   // creating the signup button
//                   SizedBox(height: 20),
//                   MaterialButton(
//                     minWidth: double.infinity,
//                     height: 60,
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => SignUpScreen()));
//                     },
//                     color: Color(0xff0095FF),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(50)),
//                     child: Text(
//                       "Sign up",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 18),
//                     ),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:found_adoption_application/screens/user_screens/login_screen.dart';
import 'package:found_adoption_application/screens/user_screens/signUp_screen.dart';

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
                      child: _bannerCard(),
                    ),
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

  Widget _bannerCard() => Container(
        height: 250,
        width: 340,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          elevation: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Welcome',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'Find the best pet near you and adopt your favorite one',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 58),
            ],
          ),
        ),
      );

  Widget _imgBanner() {
    return Container(
      height: 350,
      child: Image(
        image: AssetImage('assets/images/dog_banner.png'),
      ),
    );
  }
}
