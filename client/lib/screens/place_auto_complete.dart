import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:found_adoption_application/utils/consts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;

Widget placesAutoCompleteTextField(TextEditingController controller) {
  print('test key: $GOOGLE_MAPS_API_KEY');
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: GooglePlaceAutoCompleteTextField(
      textEditingController: controller,
      googleAPIKey: GOOGLE_MAPS_API_KEY,
      inputDecoration: InputDecoration(
        hintText: "Your Address",
        labelText: 'Address',
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        // Sử dụng cùng một icon và màu sắc như TextFormField
        icon: Icon(
          Icons.location_on,
          color: const Color.fromRGBO(48, 96, 96, 1.0),
        ),
      ),
      debounceTime: 400,
      countries: const ["vn"],
      isLatLngRequired: false,
      getPlaceDetailWithLatLng: (Prediction prediction) {
        print("placeDetails" + prediction.lat.toString());
      },
      itemClick: (Prediction prediction) {
        controller.text = prediction.description ?? "";
        controller.selection = TextSelection.fromPosition(
            TextPosition(offset: prediction.description?.length ?? 0));
      },
      seperatedBuilder: Divider(),
      itemBuilder: (context, index, Prediction prediction) {
        return Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              // Sử dụng cùng một icon và màu sắc như TextFormField
              Icon(Icons.location_on,
                  color: const Color.fromRGBO(48, 96, 96, 1.0)),
              SizedBox(
                width: 7,
              ),
              Expanded(child: Text("${prediction.description ?? ""}"))
            ],
          ),
        );
      },
      isCrossBtnShown: true,
    ),
  );
}

// Future<LatLng> convertAddressToLatLng(String inputAddress) async {
//   LatLng coordinate;
//   try {
//     // final apiKey =
//     //     'AIzaSyCunrFgaswY3SoT4komcOrXo_4bhHfdHsU'; // Thay thế bằng API key của bạn
//     final endpoint =
//         'https://maps.googleapis.com/maps/api/geocode/json?address=$inputAddress&key=$GOOGLE_MAPS_API_KEY';

//     final response = await http.get(Uri.parse(endpoint));
//     print('aaaaaa');

//     if (response.statusCode == 200) {
//       print('aaabbbbaaa');
//       final data = json.decode(response.body);
//       final location = data['results'][0]['geometry']['location'];

//       // result = 'LatLng(${location['lat']}, ${location['lng']})';
//       coordinate = LatLng(location['lat'], location['lng']);
//       print('tọa độ mới: $coordinate');
//     } else {
//       throw Exception('Failed to load data');
//     }
//     return coordinate;
//   } catch (e) {
//     print('hello: ${e.toString()}');
//     return LatLng(0.0, 0.0);
//   }
// }



Future<LatLng> convertAddressToLatLng(String inputAddress) async {
  LatLng coordinate;
  try {
    // Thay thế bằng API key của bạn
    const apiKey = 'AIzaSyDYwGbz4F815dZreWn-rUqR8HK7wyChHtI';


    final encodedAddress = Uri.encodeComponent(inputAddress);
    print('test 111: $encodedAddress');

    final endpoint =
        'http://maps.googleapis.com/maps/api/geocode/json?address=$encodedAddress&key=$apiKey';

    final response = await http.get(Uri.parse(endpoint));
    print('test endpoint: $endpoint');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (data['status'] == 'OK') {
        final location = data['results'][0]['geometry']['location'];
        coordinate = LatLng(location['lat'], location['lng']);
        print('Tọa độ mới: $coordinate');
      } else {
        throw Exception('Geocoding failed: ${data['status']}');
      }
    } else {
      throw Exception('Failed to load data');
    }

    return coordinate;
  } catch (e) {
    print('Error: ${e.toString()}');
    return LatLng(0.0, 0.0);
  }
}

