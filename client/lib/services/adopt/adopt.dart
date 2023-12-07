import 'dart:convert';
import 'package:found_adoption_application/services/api.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';

Future<String> createAdopt(String petId, String descriptionAdoption) async {
  try {
    var body =
        jsonEncode({'petId': petId, 'descriptionAdoption': descriptionAdoption});
    var responseData = await api('/adopt', 'POST', body);
    print(responseData);

    if (responseData['success'] as bool) {
     notification(responseData['message'], false);
      return responseData['id'];
    }
    else{
      notification(responseData['message'], true);
    }
  } catch (e) {
    print(e.toString());
    notification("Adopt: ${e.toString()}", true);
  }
  return '';
}

// Future<dynamic> createAdopt(String content) async {
//   try {
//     var body = jsonEncode({});
//   } catch (e) {
//     Fluttertoast.showToast(
//       msg: e.toString(),
//       toastLength: Toast.LENGTH_SHORT, // Thời gian hiển thị
//       gravity: ToastGravity.BOTTOM, // Vị trí hiển thị
//       timeInSecForIosWeb: 1, // Thời gian hiển thị cho iOS và web
//       backgroundColor: Colors.red[20], // Màu nền của toast
//       textColor: Colors.white, // Màu chữ của toast
//       fontSize: 16.0,
//     ); // Kích thước chữ của toast
//   }
// }
