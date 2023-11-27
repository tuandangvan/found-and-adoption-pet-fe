// import 'package:comment_box/comment/comment.dart';
// import 'package:flutter/material.dart';

// class CommentScreen extends StatefulWidget {
//   CommentScreen({
//     super.key,
//   });

//   @override
//   _CommentScreenState createState() => _CommentScreenState();
// }

// class _CommentScreenState extends State<CommentScreen> {
//   final formKey = GlobalKey<FormState>();
//   final TextEditingController commentController = TextEditingController();
//   List filedata = [
//     {
//       'name': 'Chuks Okwuenu',
//       'pic': 'assets/images/Lan.jpg',
//       'message': 'I love to code',
//       'date': '2021-01-01 12:00:00'
//     },
//     {
//       'name': 'Biggi Man',
//       'pic': 'assets/images/Lan.jpg',
//       'message': 'Very cool',
//       'date': '2021-01-01 12:00:00'
//     },
//     {
//       'name': 'Tunde Martins',
//       'pic': 'assets/images/Lan.jpg',
//       'message': 'Very cool',
//       'date': '2021-01-01 12:00:00'
//     },
//     {
//       'name': 'Biggi Man',
//       'pic': 'assets/images/Lan.jpg',
//       'message': 'Very cool',
//       'date': '2021-01-01 12:00:00'
//     },
//   ];

//   Widget commentChild(data) {
//     return ListView(
//       children: [
//         for (var i = 0; i < data.length; i++)
//           Padding(
//             padding: const EdgeInsets.fromLTRB(0.0, 4.0, 2.0, 0.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   leading: GestureDetector(
//                     onTap: () async {
//                       // Hiển thị hình ảnh ở kích thước lớn.
//                       print("Comment Clicked");
//                     },
//                     child: Container(
//                       height: 50.0,
//                       width: 50.0,
//                       decoration: BoxDecoration(
//                         color: Colors.blue,
//                         borderRadius: BorderRadius.all(Radius.circular(50)),
//                       ),
//                       child: CircleAvatar(
//                         radius: 50,
//                         backgroundImage: CommentBox.commentImageParser(
//                           imageURLorPath: data[i]['pic'],
//                         ),
//                       ),
//                     ),
//                   ),
//                   title: Container(
//                     padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           data[i]['name'],
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                         Text(
//                           data[i]['message'],
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ],
//                     ),
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         color: Colors.grey.shade200),
//                   ),
//                   trailing: IconButton(
//                       onPressed: () {},
//                       icon: const Icon(
//                         Icons.favorite,
//                         color: Colors.red,
//                       )),
//                   // Đặt Row ngay sau ListTile
//                 ),
//                 // Padding(
//                 //   padding: const EdgeInsets.only(left: 67),
//                 //   child: Row(
//                 //     children: [
//                 //       IconButton(
//                 //         icon: Icon(Icons.thumb_up),
//                 //         onPressed: () {
//                 //           // Xử lý khi người dùng nhấn nút Like
//                 //         },
//                 //       ),
//                 //       const SizedBox(
//                 //         width: 10,
//                 //       ),
//                 //       IconButton(
//                 //         icon: Icon(Icons.reply),
//                 //         onPressed: () {
//                 //           // Xử lý khi người dùng nhấn nút Reply
//                 //         },
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               height: 5,
//               width: 45,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.grey.shade300),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               'Comment',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             // Khoảng cách giữa "Comment" và dấu gạch ngang
//             SizedBox(height: 4),
//           ],
//         ),
//         // actions: [
//         //   IconButton(
//         //     icon: Icon(
//         //       Icons.send_sharp,
//         //       color: Colors.black,
//         //     ),
//         //     onPressed: () {
//         //       // Xử lý khi nhấn nút gửi
//         //     },
//         //   ),
//         // ],
//       ),
//       body: Column(
//         children: [
//           Divider(
//             color: Colors.grey.shade200,
//             height: 1, // Chiều cao của đường gạch ngang
//           ),
//           Expanded(
//             child: Container(
//               child: CommentBox(
//                 userImage: CommentBox.commentImageParser(
//                     imageURLorPath: "assets/images/Lan.jpg"),
//                 child: commentChild(filedata),
//                 labelText: 'Write a comment...',
//                 errorText: 'Comment cannot be blank',
//                 withBorder: false,
//                 sendButtonMethod: () {
//                   if (formKey.currentState!.validate()) {
//                     print(commentController.text);
//                     setState(() {
//                       var value = {
//                         'name': 'New User',
//                         'pic':
//                             'https://lh3.googleusercontent.com/a-/AOh14GjRHcaendrf6gU5fPIVd8GIl1OgblrMMvGUoCBj4g=s400',
//                         'message': commentController.text,
//                         'date': '2021-01-01 12:00:00'
//                       };
//                       filedata.insert(0, value);
//                     });
//                     commentController.clear();
//                     FocusScope.of(context).unfocus();
//                   } else {
//                     print("Not validated");
//                   }
//                 },
//                 formKey: formKey,
//                 commentController: commentController,
//                 backgroundColor: Colors.pink,
//                 textColor: Colors.white,
//                 sendWidget:
//                     Icon(Icons.send_sharp, size: 30, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/comments.dart';
import 'package:found_adoption_application/models/current_user.dart';
import 'package:found_adoption_application/models/user.dart' as UserComment;
import 'package:found_adoption_application/repository/get_comment.dart';
import 'package:found_adoption_application/repository/post_comment.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class CommentScreen extends StatefulWidget {
  final postId;
  CommentScreen({super.key, required this.postId});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  late Future<List<Comment>> commentsFuture;
  late io.Socket socket;

  @override
  void initState() {
    super.initState();

    // Khởi tạo kết nối Socket.IO
    socket = io.io('http://socket-found-adoption-dangvantuan.koyeb.app', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on('comment', (data) {
      setState(() {

        UserComment.User userCmt = new UserComment.User(
            id: '',
            firstName: 'Tuan',
            lastName: 'Dang',
            avatar:
                'https://res.cloudinary.com/dfaea99ew/image/upload/v1698469989/a1rstfzd5ihov6sqhvck.jpg');
        Comment newComment = Comment(
          userId: userCmt,
          id: '45343ert',
          content: data['content'],
          createdAt: "20-11-2023",
        );

        // Thêm comment mới vào danh sách commentsFuture
        commentsFuture.then((comments) {
          comments.add(newComment);
          return comments;
        });
      });
    });

    // Gọi hàm getComment trong initState để lấy dữ liệu khi widget được tạo
    commentsFuture = getComment(widget.postId);
    // Thực hiện các thao tác khác liên quan đến việc kết nối Socket.IO
  }

  //comment
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
            comments = snapshot.data!;
            return ListView(
              children: [
                for (int i = 0; i < comments.length; i++)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 4.0, 2.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: GestureDetector(
                            onTap: () async {
                              print('testtttt: ${comments[i].content}');
                              // Hiển thị hình ảnh ở kích thước lớn.
                              print("Comment Clicked");
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
                                  // imageURLorPath: data[i]['pic'],
                                  imageURLorPath: comments[i].userId != null
                                      ? '${comments[i].userId!.avatar}'
                                      : comments[i].centerId!.avatar,
                                ),
                              ),
                            ),
                          ),
                          title: Container(
                            padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // data[i]['name'],
                                  comments[i].userId != null
                                      ? '${comments[i].userId!.firstName} ${comments[i].userId!.lastName}'
                                      : comments[i].centerId!.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  // data[i]['message'],
                                  comments[i].content,
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
                  ),
              ],
            );
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
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.send_sharp,
        //       color: Colors.black,
        //     ),
        //     onPressed: () {
        //       // Xử lý khi nhấn nút gửi
        //     },
        //   ),
        // ],
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
                userImage: CommentBox.commentImageParser(
                    imageURLorPath: "assets/images/Lan.jpg"),
                child: commentChild([]),
                labelText: 'Write a comment...',
                errorText: 'Comment cannot be blank',
                withBorder: false,
                sendButtonMethod: () {
                  if (formKey.currentState!.validate()) {
                    print(commentController.text);
                    setState(() {
                      // var value = {
                      //   'name': 'New User',
                      //   'pic':
                      //       'https://lh3.googleusercontent.com/a-/AOh14GjRHcaendrf6gU5fPIVd8GIl1OgblrMMvGUoCBj4g=s400',
                      //   'message': commentController.text,
                      //   'date': '2021-01-01 12:00:00'
                      // };
                      // comments.insert(0, value);

                      postComment(
                          widget.postId, commentController.text.toString());

                      // Gửi comment thông qua Socket.IO
                      socket.emit('comment', {
                        'postId': widget.postId,
                        'content': commentController.text
                      });
                    });
                    commentController.clear();
                    FocusScope.of(context).unfocus();
                  } else {
                    print("Not validated");
                  }
                },
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
}
