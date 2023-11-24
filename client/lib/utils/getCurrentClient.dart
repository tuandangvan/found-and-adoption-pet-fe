import 'package:hive/hive.dart';

Future getCurrentClient() async {
  var userBox = await Hive.openBox('userBox'); // Lấy Hive box đã mở
  var centerBox = await Hive.openBox('centerBox');

  var currentUser = userBox.get('currentUser');
  var currentCenter = centerBox.get('currentCenter');

  var currentClient = currentUser != null && currentUser.role == 'USER'
      ? currentUser
      : currentCenter;
  return currentClient;
}
