import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:found_adoption_application/repository/call_back_api.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';

import 'package:http/http.dart' as http;

Future<void> like(BuildContext context, postId) async {

  var currentClient = await getCurrentClient();
  var responseData;
  try {
    final apiUrl = Uri.parse(
        "https://found-and-adoption-pet-api-be.vercel.app/api/v1/post/${postId}/reaction");

    final response = await http.put(
      apiUrl,
      headers: {
        'Authorization': 'Bearer ${currentClient.accessToken}',
        'Content-Type': 'application/json',
      },
    );
    responseData = json.decode(response.body);

    if (responseData['message'] == 'jwt expired') {
      responseData = await callBackApi(apiUrl, "put", null);
    }
  } catch (e) {
    print(e);
  }
}
