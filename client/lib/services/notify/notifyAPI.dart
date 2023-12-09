import 'package:found_adoption_application/models/notify.dart';
import 'package:found_adoption_application/services/api.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';

Future<List<Notify>> getStatusAdoptCenter(String status) async {
  var responseData;
  try {
    responseData = await api('/notify/', 'GET', '');

    if (responseData['success']) {
      var adoptList = responseData['data'] as List<dynamic>;
      List<Notify> adopts =
          adoptList.map((json) => Notify.fromJson(json)).toList();
      return adopts;
    }
  } catch (e) {
    print(e);
    notification(e.toString(), true);
  }
  // ignore: cast_from_null_always_fails
  return null as List<Notify>;
}