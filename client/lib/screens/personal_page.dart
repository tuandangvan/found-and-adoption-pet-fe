import 'package:flutter/material.dart';

class PersonalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserProfilePage(),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Column(
        children: [
          // 1. Cover Photo
          Container(
            color: Theme.of(context).primaryColor,
            height: 150,
            // You can add user's cover photo here
            // Add an Image or any other widget of your choice
          ),

          // 2. Profile Info
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2.1 User's Profile Picture
                CircleAvatar(
                  radius: 50,
                  // You can add user's profile picture here
                  // Add an Image or any other widget of your choice
                ),

                SizedBox(height: 16),

                // 2.2 User's Name
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),

                SizedBox(height: 8),

                // 2.3 User's Bio
                Text(
                  'Software Developer | Flutter Enthusiast',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          // 3. Tabs for Posts, Photos, Friends, etc. (Optional)
          DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.article)),
                    Tab(icon: Icon(Icons.photo)),
                    Tab(icon: Icon(Icons.people)),
                  ],
                ),
                TabBarView(
                  children: [
                    // 3.1 User's Posts
                    Center(child: Text('User Posts')),

                    // 3.2 User's Photos
                    Center(child: Text('User Photos')),

                    // 3.3 User's Friends
                    Center(child: Text('User Friends')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
