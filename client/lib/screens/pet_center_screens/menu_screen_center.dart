import 'package:flutter/material.dart';
import 'package:found_adoption_application/main.dart';
import 'package:found_adoption_application/screens/welcome_screen.dart';
import 'package:hive/hive.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuCenterScreen extends StatefulWidget {
  final Function(int) menuCallBack;
  MenuCenterScreen({super.key, required this.menuCallBack});

  @override
  State<MenuCenterScreen> createState() => _MenuCenterScreenState();
}

class _MenuCenterScreenState extends State<MenuCenterScreen> {
  int selectedMenuIndex = 0;

  List<String> menuItems = [
    'Adoption',
    'Pet Story',
    'Profile',
    'Add pet',
    'Manage Adopt',
    'Notify',
    // 'Messages',
  ];

  List<IconData> icons = [
    FontAwesomeIcons.paw,
    FontAwesomeIcons.newspaper,
    FontAwesomeIcons.userAlt,
    FontAwesomeIcons.plus,
    FontAwesomeIcons.checkToSlot,
    FontAwesomeIcons.bell,
    // FontAwesomeIcons.envelope,
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
            const SizedBox(width: 5),
            Text(
              menuItems[index],
              style: TextStyle(
                  color: selectedMenuIndex == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                  fontSize: 18,
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
                      backgroundImage: AssetImage('assets/images/Lan.jpg')
                    ),
                    SizedBox(width: 16),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trung tâm abc',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 20),
                          ),
                          Row(
      children: [
        Icon(
          Icons.circle, // Chọn một icon màu xanh, ví dụ: đánh dấu đúng (check mark)
          color: Colors.green, // Màu xanh
          size: 12,
        ),
        SizedBox(width: 8.0), // Khoảng cách giữa icon và văn bản
        Text(
          'Đang hoạt động',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
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
                    // Icon(
                    //   FontAwesomeIcons.gear,
                    //   color: Colors.white.withOpacity(0.5),
                    // ),
                    // SizedBox(width: 16),
                    // TextButton(
                    //   onPressed: () {},
                    //   child: Text(
                    //     'Settings      |',
                    //     style: TextStyle(
                    //         color: Colors.white.withOpacity(0.5),
                    //         fontSize: 20,
                    //         fontWeight: FontWeight.w600),
                    //   ),
                    // ),
                    Icon(
                      Icons.logout_rounded,
                      color: Colors.white.withOpacity(0.5)
                    ),
                    TextButton(
                        onPressed: () async {
                          _showLogoutDialog(context);
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

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log out'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You are about to log out. Are you sure?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Log out'),
              onPressed: () async {
                Navigator.of(context).pop();
                //Navigate
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => WelcomeScreen())));

                var userBox = await Hive.openBox('userBox');
                await userBox.put('currentUser', null);

                var centerBox = await Hive.openBox('centerBox');
                await centerBox.put('currentCenter', null);
              },
            ),
          ],
        );
      },
    );
  }
}
