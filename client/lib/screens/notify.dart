import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(48, 96, 96, 1.0),
        title: Row(
          children: [
            Icon(
              Icons.notifications_active_sharp,
              color: Colors.white,
            ),
            SizedBox(width: 12.0),
            Text(
              'Notification',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: notificationData.length,
        itemBuilder: (context, index) {
          return NotificationCard(notificationData[index]);
        },
      ),
    );
  }
}

class NotificationCard extends StatefulWidget {
  final NotificationModel notification;

  NotificationCard(this.notification);

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    String timeAgo =
        timeago.format(widget.notification.time, locale: 'en_short');

    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 2.0,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30.0,
          backgroundImage: AssetImage(widget.notification.avatar),
        ),
        title: Text(
          widget.notification.userName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.notification.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Sent $timeAgo',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 4.0),
            Text(widget.notification.content),
          ],
        ),
      ),
    );
  }
}

class NotificationModel {
  final String avatar;
  final String userName;
  final String title;
  final String content;
  final DateTime time;

  NotificationModel({
    required this.avatar,
    required this.userName,
    required this.title,
    required this.content,
    required this.time,
  });
}

// Dữ liệu giả định cho thông báo
List<NotificationModel> notificationData = [
  NotificationModel(
    avatar: 'assets/images/Lan.jpg',
    userName: 'UserA',
    title: 'New Message',
    content: 'You have a new message from UserB.',
    time: DateTime.now().subtract(Duration(minutes: 2)),
  ),
  NotificationModel(
    avatar: 'assets/images/Lan.jpg',
    userName: 'UserC',
    title: 'Friend Request',
    content: 'UserD sent you a friend request.',
    time: DateTime.now().subtract(Duration(hours: 6)),
  ),
  NotificationModel(
    avatar: 'assets/images/Lan.jpg',
    userName: 'UserE',
    title: 'New Post',
    content: 'UserF just posted a new photo.',
    time: DateTime.now().subtract(Duration(days: 1)),
  ),
];
