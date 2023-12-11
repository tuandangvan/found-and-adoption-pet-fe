import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/welcome_screen.dart';
import 'package:hive/hive.dart';
import '../../main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuUserScreen extends StatefulWidget {
  final Function(int) menuCallBack;
  MenuUserScreen({super.key, required this.menuCallBack});

  @override
  State<MenuUserScreen> createState() => _MenuUserScreenState();
}

class _MenuUserScreenState extends State<MenuUserScreen> {
  int selectedMenuIndex = 0;

  List<String> menuItems = [
    'Adoption',
    'Pet Stories',
    'Profile',
    'Manager Adopt',
    'Notify',
    'Favorite',
    'Messages',
  ];

  List<IconData> icons = [
    FontAwesomeIcons.paw,
    FontAwesomeIcons.newspaper,
    FontAwesomeIcons.userAlt,
    FontAwesomeIcons.checkToSlot,
    FontAwesomeIcons.envelope,
    FontAwesomeIcons.heart,
    FontAwesomeIcons.envelope,
  ];

  Widget buildMenuRow(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedMenuIndex = index;
          widget.menuCallBack(index);
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Row(
          children: [
            Icon(
              icons[index],
              color: selectedMenuIndex == index
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
            ),
            SizedBox(width: 16),
            Text(
              menuItems[index],
              style: TextStyle(
                  color: selectedMenuIndex == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [startingColor, mainColor],
        )),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 24.0,
                      backgroundColor: Colors.orange,
                    ),
                    SizedBox(width: 16),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ryan',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          ),
                          Text(
                            'Active Status',
                            style: TextStyle(color: Colors.white),
                          ),
                        ])
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: menuItems
                      .asMap()
                      .entries
                      .map((MapEntry) => buildMenuRow(MapEntry.key))
                      .toList(),
                ),
                Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.gear,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    SizedBox(width: 16),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Settings      |',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          //Navigate
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => WelcomeScreen())));

                          var userBox = await Hive.openBox('userBox');
                          await userBox.put('currentUser', null);

                          var centerBox = await Hive.openBox('centerBox');
                          await centerBox.put('currentCenter', null);
                          //Close Hive
                          // await Hive.close();
                        },
                        child: Text(
                          '   Log out',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
