import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/comments.dart';

class LikeScreen extends StatefulWidget {
  final postId;
  LikeScreen({super.key, required this.postId});

  @override
  _LikeScreenState createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  late Future<List<Comment>> commentsFuture;

  @override
  void initState() {
    super.initState();
  }

  // //comment
  Widget commentChild(List<Comment> comments) {
    return FutureBuilder(
        future: commentsFuture,
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

            return ListView.builder(
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
                            },
                            child: Container(
                              height: 50.0,
                              width: 50.0,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: CommentBox.commentImageParser(
                                  
                                  imageURLorPath: 'https://res.cloudinary.com/dfaea99ew/image/upload/v1698469989/a1rstfzd5ihov6sqhvck.jpg',
                                  // imageURLorPath: comments[index].userId != null
                                  //     ? '${comments[index].userId!.avatar}'
                                  //     : '${comments[index].centerId!.avatar}',
                                ),
                              ),
                            ),
                          ),
                          title: Container(
                            padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Dang Van Tuan',
                                  // data[i]['name'],
                                  // comments[index].userId != null
                                  //     ? '${comments[index].userId!.firstName} ${comments[index].userId!.lastName}'
                                  //     : '${comments[index].centerId!.name}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  // data[i]['message'],
                                  'abc',
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
        });
    //tất cả các cmt của 1 bài post
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 5,
              width: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade300),
            ),
            const SizedBox(height: 10),
            Text(
              'Comment',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Khoảng cách giữa "Comment" và dấu gạch ngang
            SizedBox(height: 4),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.send_sharp,
              color: Colors.black,
            ),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Divider(
            color: Colors.grey.shade200,
            height: 1, // Chiều cao của đường gạch ngang
          ),
          Expanded(
            child: Container(
              child: CommentBox(
                userImage:
                    CommentBox.commentImageParser(imageURLorPath: 'https://res.cloudinary.com/dfaea99ew/image/upload/v1698469989/a1rstfzd5ihov6sqhvck.jpg'),
                child: commentChild([]),
                labelText: 'Write a comment...',
                errorText: 'Comment cannot be blank',
                withBorder: false,
                formKey: formKey,
                commentController: commentController,
                backgroundColor: Colors.pink,
                textColor: Colors.white,
                sendWidget:
                    Icon(Icons.send_sharp, size: 30, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
