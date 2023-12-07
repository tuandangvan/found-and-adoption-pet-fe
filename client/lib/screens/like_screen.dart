import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/like_model.dart';
import 'package:found_adoption_application/screens/feed_screen.dart';
import 'package:found_adoption_application/screens/pet_center_screens/profile_center.dart';
import 'package:found_adoption_application/screens/user_screens/profile_user.dart';
import 'package:found_adoption_application/services/post/like_post_api.dart';

class LikeScreen extends StatefulWidget {
  final postId;
  LikeScreen({super.key, required this.postId});

  @override
  _LikeScreenState createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  Future<List<Like>>? likeFuture;

  @override
  void initState() {
    super.initState();
    likeFuture = getLike(context, widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Back'),
          leading: IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedScreen()),
              );
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
        body: FutureBuilder(
            future: likeFuture,
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
                List<Like> likes = snapshot.data as List<Like>;

                return ListView.builder(
                    itemCount: likes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 4.0, 2.0, 0.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: GestureDetector(
                                onTap: () async {
                                  likes[index].userId != null
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ProfilePage(
                                                  userId:
                                                      likes[index].userId!.id)))
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileCenterPage(
                                                    centerId: likes[index]
                                                        .centerId!
                                                        .id),
                                          ),
                                        );
                                },
                                child: Container(
                                  height: 50.0,
                                  width: 50.0,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        CommentBox.commentImageParser(
                                      // imageURLorPath: 'https://res.cloudinary.com/dfaea99ew/image/upload/v1698469989/a1rstfzd5ihov6sqhvck.jpg',
                                      imageURLorPath: likes[index].userId !=
                                              null
                                          ? '${likes[index].userId!.avatar}'
                                          : '${likes[index].centerId!.avatar}',
                                    ),
                                  ),
                                ),
                              ),
                              title: Container(
                                padding:
                                    EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          likes[index].userId != null
                                              ? Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfilePage(
                                                              userId:
                                                                  likes[index]
                                                                      .userId!
                                                                      .id)))
                                              : Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProfileCenterPage(
                                                            centerId:
                                                                likes[index]
                                                                    .centerId!
                                                                    .id),
                                                  ),
                                                );
                                        },
                                        child: Container(
                                            child: Text(
                                          // data[i]['name'],
                                          likes[index].userId != null
                                              ? '${likes[index].userId!.firstName} ${likes[index].userId!.lastName}'
                                              : '${likes[index].centerId!.name}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ))),
                                    Text(
                                      '',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey.shade200),
                              ),
                              trailing: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )),
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                return SizedBox.shrink();
              }
            }));
  }
}
