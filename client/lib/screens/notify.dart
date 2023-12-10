import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/notify.dart';
import 'package:found_adoption_application/services/notify/notifyAPI.dart';
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
      body: FutureBuilder(
          future: getNotify(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              List<Notify> notifies = snapshot.data as List<Notify>;
              return ListView.builder(
                itemCount: notifies.length,
                itemBuilder: (context, index) {
                  return NotificationCard(notifies[index]);
                },
              );
            } else {
              return const Center(
                child: Icon(
                  Icons.cloud_off, // Thay thế bằng icon bạn muốn sử dụng
                  size: 48.0,
                  color: Colors.grey,
                ),
              );
            }
          }),
    );
  }
}

class NotificationCard extends StatefulWidget {
  final Notify notifies;

  NotificationCard(this.notifies);

  @override
  _NotificationCardState createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    String timeAgo = timeago.format(
        widget.notifies.createdAt!.subtract(Duration(minutes: 2)),
        locale: 'en_short');

    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 2.0,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30.0,
          backgroundImage: NetworkImage(widget.notifies.avatar),
        ),
        title: Text(
          widget.notifies.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.notifies.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Sent $timeAgo',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 4.0),
            Text(widget.notifies.content),
          ],
        ),
      ),
    );
  }
}

// class NotificationModel {
//   final String avatar;
//   final String userName;
//   final String title;
//   final String content;
//   final DateTime time;

//   NotificationModel({
//     required this.avatar,
//     required this.userName,
//     required this.title,
//     required this.content,
//     required this.time,
//   });
// }

// // Dữ liệu giả định cho thông báo
// List<NotificationModel> notificationData = [
//   NotificationModel(
//     avatar: 'assets/images/Lan.jpg',
//     userName: 'UserA',
//     title: 'New Message',
//     content: 'You have a new message from UserB.',
//     time: DateTime.now().subtract(Duration(minutes: 2)),
//   ),
//   NotificationModel(
//     avatar: 'assets/images/Lan.jpg',
//     userName: 'UserC',
//     title: 'Friend Request',
//     content: 'UserD sent you a friend request.',
//     time: DateTime.now().subtract(Duration(hours: 6)),
//   ),
//   NotificationModel(
//     avatar: 'assets/images/Lan.jpg',
//     userName: 'UserE',
//     title: 'New Post',
//     content: 'UserF just posted a new photo.',
//     time: DateTime.now().subtract(Duration(days: 1)),
//   ),
// ];
