import 'package:flutter/material.dart';

import 'package:found_adoption_application/models/current_center.dart';

import 'package:found_adoption_application/models/current_user.dart';
import 'package:found_adoption_application/screens/pet_center_screens/add_pet_screen.dart';

import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';

import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';

import 'package:found_adoption_application/screens/welcome_screen.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CenterAdapter());

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
//       home: AddPetScreen(),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  Future<bool> hasValidRefreshToken = checkRefreshToken();
  late io.Socket socket;
  var serverUrl = 'http://socket-found-adoption-dangvantuan.koyeb.app';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: hasValidRefreshToken,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final refreshTokenIsValid = snapshot.data;
          print('Giá trị của refreshToken is Valid: ${refreshTokenIsValid}');
          if (refreshTokenIsValid != false) {
            //CHECK ROLE
            return FutureBuilder<Box>(
              future: Hive.openBox('userBox'),
              builder: (context, userBoxSnapshot) {
                if (userBoxSnapshot.connectionState == ConnectionState.done) {
                  var userBox = userBoxSnapshot.data;
                  return FutureBuilder<Box>(
                    future: Hive.openBox('centerBox'),
                    builder: (context, centerBoxSnapshot) {
                      if (centerBoxSnapshot.connectionState ==
                          ConnectionState.done) {
                        var centerBox = centerBoxSnapshot.data;
                        var currentUser = userBox!.get('currentUser');
                        var currentCenter = centerBox!.get('currentCenter');

                        var currentClient =
                            currentUser != null && currentUser.role == 'USER'
                                ? currentUser
                                : currentCenter;

                        if (currentClient != null) {
                          //connect socket server
                          socket = io.io(serverUrl, <String, dynamic>{
                            'transports': ['websocket'],
                            'autoConnect': true,
                          });
                          
                          print(socket.io.toString());

                          if (currentClient.role == 'USER') {
                            print("den day");
                            socket.emit(
                                'addNewUser', {'userId': currentClient.id});
                            print("shkfd");
                            return MaterialApp(
                              title: 'Flutter Demo',
                              debugShowCheckedModeBanner: false,
                              theme: ThemeData(
                                primaryColor: mainColor,
                              ),
                              home: MenuFrameUser(),
                            );
                          } else if (currentClient.role == 'CENTER') {
                            socket.emit(
                                'addNewUser', {'userId': currentClient.id});
                            return MaterialApp(
                              title: 'Flutter Demo',
                              debugShowCheckedModeBanner: false,
                              theme: ThemeData(
                                primaryColor: mainColor,
                              ),
                              home: MenuFrameCenter(),
                            );
                          }
                        }
                      }
                      return CircularProgressIndicator();
                    },
                  );
                }
                return CircularProgressIndicator();
              },
            );
          } else {
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
        return CircularProgressIndicator();
      },
    );
  }
}

// class MyApp extends StatelessWidget {
//   // Đặt biến hasValidRefreshToken là một Future<bool>
//   Future<bool> hasValidRefreshToken = checkRefreshToken();

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool>(
//       future: hasValidRefreshToken,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           final refreshTokenIsValid = snapshot.data;
//           if (refreshTokenIsValid != null) {

//             return MaterialApp(
//               title: 'Flutter Demo',
//               debugShowCheckedModeBanner: false,
//               theme: ThemeData(
//                 primaryColor: mainColor,
//               ),
//               home: refreshTokenIsValid ? MenuFrame() : WelcomeScreen(),
//             );
//           } else {
//             // Xử lý trường hợp biến là null
//             return CircularProgressIndicator();
//           }
//         } else {
//           return CircularProgressIndicator();
//         }
//       },
//     );
//   }
// }

Future<bool> checkRefreshToken() async {
  try {
    var userBox = await Hive.openBox('userBox');
    var currentUser = userBox.get('currentUser');

    var centerBox = await Hive.openBox('centerBox');
    var currentCenter = centerBox.get('currentCenter');

    var currentClient = currentUser != null && currentUser.role == 'USER'
        ? currentUser
        : currentCenter;

    var clientBox =
        currentUser != null && currentUser.role == 'USER' ? userBox : centerBox;

    var name = currentUser != null && currentUser.role == 'USER'
        ? currentUser.firstName
        : currentCenter.name;

    final refreshTokenTimestamp = clientBox.get('refreshTokenTimestamp');
    const refreshTokenValidityDays = 7;
    final DateTime now = DateTime.now();

    if (currentClient != null) {
      final expirationTime = refreshTokenTimestamp.add(
        Duration(days: refreshTokenValidityDays),
      );
      print('The current client is Logged in at: ${refreshTokenTimestamp}');
      print('The RefreshToken is expired at: ${expirationTime}');
      print('The currentClient is ${name} with role: ${currentClient.role}');

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
