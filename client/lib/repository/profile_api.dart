import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/userCenter.dart';
import 'package:found_adoption_application/models/userInfo.dart';
import 'package:found_adoption_application/repository/call_back_api.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:http/http.dart' as http;

Future<InfoUser> getProfile(BuildContext context) async {
  var currentClient = await getCurrentClient();
  var id = currentClient.id;
  var accessToken = currentClient.accessToken;
  var user;
  try {
    var responseData;
    final apiUrl = Uri.parse("http://10.0.2.2:8050/api/v1/user/${id}");

    var response = await http.get(apiUrl, headers: {
      'Authorization': 'Bearer ${accessToken}',
    });
    responseData = json.decode(response.body);
    // print('Response get ALL POST: $responseData');

    if (responseData['message'] == 'jwt expired') {
      responseData = callBackApi(apiUrl, "get", "");
    }
    var userData = responseData['user'];
    user = InfoUser.fromJson(userData);
  } catch (e) {
    print(e);
  }
  return user;
}

Future<void> updateProfile(
    BuildContext context, firstName, lastName, phoneNumber, address, experience) async {
  var currentClient = await getCurrentClient();
  var id = currentClient.id;
  var accessToken = currentClient.accessToken;
  try {
    var responseData;
    var body = jsonEncode(<String, dynamic>{
      if (firstName != "") 'firstName': firstName,
      if (lastName != "") 'lastName': lastName,
      if (phoneNumber != "") 'phoneNumber': phoneNumber,
      if (address != "") 'address': address,
      'experience': experience
    });

    if (body == jsonEncode(<String, String>{})) {
      print("No something change!");
      return;
    }

    final apiUrl = Uri.parse("http://10.0.2.2:8050/api/v1/user/${id}");

    var response = await http.put(apiUrl,
        headers: {
          'Authorization': 'Bearer ${accessToken}',
          'Content-Type': 'application/json',
        },
        body: body);
    responseData = json.decode(response.body);

    if (responseData['message'] == 'jwt expired') {
      responseData = await callBackApi(apiUrl, "put", body);
    }
    if (responseData['success']) {
      print("update success");
    }
  } catch (e) {
    print(e);
  }
}

Future<InfoCenter> getProfileCenter(BuildContext context) async {
  var currentClient = await getCurrentClient();
  var id = currentClient.id;
  var accessToken = currentClient.accessToken;
  var center;
  try {
    var responseData;
    final apiUrl = Uri.parse("http://10.0.2.2:8050/api/v1/center/${id}");

    var response = await http.get(apiUrl, headers: {
      'Authorization': 'Bearer ${accessToken}',
    });
    responseData = json.decode(response.body);

    if (responseData['message'] == 'jwt expired') {
      responseData = callBackApi(apiUrl, "get", "");
    }
    var centerData = responseData['center'] as dynamic;
    center = InfoCenter.fromJson(centerData);
  } catch (e) {
    print(e);
  }
  return center;
}

Future<void> updateProfileCenter(
    BuildContext context, name, phoneNumber, address) async {
  var currentClient = await getCurrentClient();
  var id = currentClient.id;
  var accessToken = currentClient.accessToken;
  try {
    var responseData;
    var body = jsonEncode(<String, String>{
      if (name != "") 'name': name,
      if (phoneNumber != "") 'phoneNumber': phoneNumber,
      if (address != "") 'address': address
    });

    if (body == jsonEncode(<String, String>{})) {
      print("No something change!");
      return;
    }

    final apiUrl = Uri.parse("http://10.0.2.2:8050/api/v1/center/${id}");

    var response = await http.put(apiUrl,
        headers: {
          'Authorization': 'Bearer ${accessToken}',
          'Content-Type': 'application/json',
        },
        body: body);
    responseData = json.decode(response.body);

    if (responseData['message'] == 'jwt expired') {
      responseData = await callBackApi(apiUrl, "put", body);
    }
    if (responseData['success']) {
      print("update success");
    }
  } catch (e) {
    print(e);
  }
}
