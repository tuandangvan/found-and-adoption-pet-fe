import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/user_screens/welcome_screen.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  int selectedRadio = 0;

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(
                  context); // Đặt hàm Navigator.pop(context) trong hàm lambda
            },
          ),
          title: Text("Registration User's Form"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        icon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        hintText: 'First Name',
                        labelText: 'First Name',
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Khoảng cách giữa hai trường
                  Expanded(
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        filled: true,
                        hintText: 'Last Name',
                        labelText: 'Last Name',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(
                      Icons.call,
                      color: Colors.blue,
                    ),
                    hintText: 'Where can we reach you',
                    labelText: 'Phone Number',
                    prefixText: '+84 '),
              ),
              SizedBox(
                height: 24,
              ),
              TextFormField(
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(
                      Icons.location_on,
                      color: Colors.blue,
                    ),
                    hintText: 'Your Address',
                    labelText: 'Address'),
              ),
              SizedBox(
                height: 24,
              ),

              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Experiences: ',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
              ),

              //Radion button Experience
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                      value: 1,
                      groupValue: selectedRadio,
                      onChanged: (val) {
                        setSelectedRadio(val!);
                      }),
                  Text('Yes'),
                  SizedBox(
                    width: 50,
                  ),
                  Radio(
                      value: 2,
                      groupValue: selectedRadio,
                      onChanged: (val) {
                        setSelectedRadio(val!);
                      }),
                  Text('No'),
                ],
              ),

              TextFormField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Tell us about yourself',
                    helperText: 'Keep it short, this is just demo',
                    labelText: 'Life Story'),
                maxLines: 4,
              ),

              SizedBox(
                height: 30,
              ),

              //Button
              MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: () {},
                color: Color(0xff0095FF),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WelcomeScreen()));
                  },
                  child: Text(
                    "Continue",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
