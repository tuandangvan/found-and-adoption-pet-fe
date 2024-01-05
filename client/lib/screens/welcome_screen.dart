import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:found_adoption_application/custom_widget/banner_card_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

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
            ],
          ),
        ),
      ),
    );
  }

  Widget _imgBanner() {
    return Container(
      height: 350,
      child:  
        Image.asset('assets/images/dog_banner.png'),
      
    );
  }
}

