import 'dart:async';

import 'package:flutter/material.dart';

Widget countdownTimer(
    BuildContext context, int remainingTime, Timer timer, bool timeIsUp) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Container(
        width: 80,
        height: 80,
        padding: const EdgeInsets.all(16),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          decoration: BoxDecoration(
            color: timeIsUp ? Colors.red : Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            timeIsUp ? Icons.lock_clock_rounded : Icons.access_time,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      Text(
        formatTime(remainingTime),
        style: TextStyle(fontSize: 20),
      ),
    ],
  );
}

String formatTime(int time) {
  int minutes = time ~/ 60;
  int seconds = time % 60;
  return '0$minutes:${seconds.toString().padLeft(2, '0')}';
}
