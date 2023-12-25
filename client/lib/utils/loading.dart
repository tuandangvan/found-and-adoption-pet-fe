import 'package:flutter/material.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';

Future<void> showLoadingDialog(
    BuildContext context, Future<void> future) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: new Container(
                width: 50.0,
                height: 50.0,
                child: new Center(
                  child: const CircularProgressIndicator(),
                ),
              ),
            );
          } 
          else return Container();
        },
      );
    },
  );
}
