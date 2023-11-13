import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/custom_widget/post_card.dart';
import 'package:found_adoption_application/models/post.dart';
import 'package:found_adoption_application/repository/get_all_post_api.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:hive/hive.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Future<List<Post>>? posts;

  @override
  void initState() {
    super.initState();
    posts = getAllPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Back'),
        leading: IconButton(
          onPressed: () async {
            var userBox = await Hive.openBox('userBox');
            var centerBox = await Hive.openBox('centerBox');

            var currentUser = userBox.get('currentUser');
            var currentCenter = centerBox.get('currentCenter');

            var currentClient =
                currentUser != null && currentUser.role == 'USER'
                    ? currentUser
                    : currentCenter;

            if (currentClient != null) {
              if (currentClient.role == 'USER') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuFrameUser()),
                );
              } else if (currentClient.role == 'CENTER') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuFrameCenter()),
                );
              }
            }
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<List<Post>>(
        future: posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Post>? postList = snapshot.data;

            if (postList != null) {
              print('Test snapshot Data: ${postList.length}');
              return ListView.builder(
                itemCount: postList.length,
                itemBuilder: (context, index) =>
                    PostCard(snap: postList[index]),
              );
            } else {
              // Xử lý trường hợp postList là null
              return Text('Post list is null');
            }
          }
        },
      ),
    );
  }
}
