import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void notification(message, isError) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT, // Thời gian hiển thị
    gravity: ToastGravity.BOTTOM, // Vị trí hiển thị
    timeInSecForIosWeb: 1, // Thời gian hiển thị cho iOS và web
    backgroundColor:
        isError ? Colors.red.shade500 : Colors.grey, // Màu nền của toast
    textColor: Colors.white, // Màu chữ của toast
    fontSize: 16.0,
  );
}
