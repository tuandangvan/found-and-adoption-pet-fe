import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/comments.dart';
import 'package:found_adoption_application/models/pet_center.dart'
    as center_comment;
import 'package:found_adoption_application/models/pet_center.dart';
import 'package:found_adoption_application/models/user.dart' as user_comment;
import 'package:found_adoption_application/models/user.dart';
import 'package:found_adoption_application/repository/get_comment.dart';
import 'package:found_adoption_application/repository/post_comment.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:hive/hive.dart';
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
  // late Future<List<Comment>> commentsFuture;
  late io.Socket socket;
  late String avatarURL = '';
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    _fetchAvatarURL();

    // Khởi tạo kết nối Socket.IO
    socket = io.io(
        'http://socket-found-adoption-dangvantuan.koyeb.app', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on("comment", (data) {
      print('data trả về cái chi rứa: $data');
      print('listen');

      _handleComment(data);
      print('chứa cái chi ở trỏng: $comments');
    });

    // Gọi hàm getComment trong initState để lấy dữ liệu khi widget được tạo
    // commentsFuture = getComment(widget.postId);
  }

  Future<void> _fetchAvatarURL() async {
    // Sử dụng await ở đây để lấy giá trị từ HiveBox
    var currentClient = await getCurrentClient();
    avatarURL = currentClient.avatar;

    if (currentClient != null) {
      setState(() {
        avatarURL = currentClient.avatar;
      });
    }
  }

  void _handleComment(data) async {
    setState(() {
      print('123456 jellooo');
      late Comment newCommentRe;

      // Extract userId data from the map
      var userIdData = data['userId'];

      // Create a User object from the userIdData
      User? userId = userIdData != null
          ? User(
              id: userIdData['_id'],
              firstName: userIdData['firstName'],
              lastName: userIdData['lastName'],
              avatar: userIdData['avatar'],
            )
          : null;

      // Extract centerId data from the map
      var centerIdData = data['centerId'];

      // Create a PetCenter object from the centerIdData
      PetCenter? centerId = centerIdData != null
          ? PetCenter(
              id: centerIdData['_id'],
              name: centerIdData['name'],
              avatar: centerIdData['avatar'],
            )
          : null;

      newCommentRe = Comment(
        id: '',
        userId: userId,
        centerId: centerId,
        commentId: '',
        content: data['content'],
        createdAt: "20-11-2023",
      );

      print('test thử xem: ${newCommentRe.userId}');

      // Thêm comment mới vào danh sách commentsFuture

      setState(() {
        comments = [...comments, newCommentRe];
        // commentsFuture = getComment(widget.postId);
      });
    });
  }

  // //comment
  Widget commentChild(comments) {
    if (comments.isEmpty) {
      return Center(
        child: Text('No comments yet.'),
      );
    }
    return FutureBuilder(
        future: getComment(widget.postId),
        builder: (context, snapshot) {
          print('FutureBuilder rebuilt');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            comments = snapshot.data as List<Comment>;

            return ListView.builder(
                itemCount: comments.length,
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
                              print('testtttt: ${comments[index].content}');
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
                                  imageURLorPath: comments[index].userId != null
                                      ? '${comments[index].userId!.avatar}'
                                      : comments[index].centerId!.avatar,
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
                                  comments[index].userId != null
                                      ? '${comments[index].userId!.firstName} ${comments[index].userId!.lastName}'
                                      : comments[index].centerId!.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  // data[i]['message'],
                                  comments[index].content,
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
    user_comment.User userCmt =
        user_comment.User(id: "", firstName: '', lastName: '', avatar: '');
    center_comment.PetCenter centerCmt =
        center_comment.PetCenter(id: '', name: '', avatar: '');

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
              // Xử lý khi nhấn nút gửi
              print('test avatarUrl: $avatarURL');
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
                    CommentBox.commentImageParser(imageURLorPath: avatarURL),
                labelText: 'Write a comment...',
                errorText: 'Comment cannot be blank',
                withBorder: false,
                sendButtonMethod: () async {
                  if (formKey.currentState!.validate()) {
                    print(commentController.text);

                    postComment(
                        widget.postId, commentController.text.toString());

                    var currentClient = await getCurrentClient();

                    if (currentClient.role == 'USER') {
                      userCmt = user_comment.User(
                          id: currentClient.id,
                          firstName: currentClient.firstName,
                          lastName: currentClient.lastName,
                          avatar: currentClient.avatar);
                    } else {
                      centerCmt = center_comment.PetCenter(
                          id: currentClient.id,
                          name: currentClient.name,
                          avatar: currentClient.avatar);
                    }

                    Comment newComment = Comment(
                        id: "",
                        userId: userCmt,
                        centerId: centerCmt,
                        content: commentController.text,
                        createdAt: "");

                    // Gửi comment thông qua Socket.IO
                    socket.emit('comment', newComment.toMap());

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
                // child: commentChild(comments),
                child: FutureBuilder<List<Comment>>(
                  future: getComment(widget.postId),
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
                      List<Comment> comments = snapshot.data!;
                      return commentChild(comments);
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Đóng kết nối Socket.IO hoặc thực hiện các tác vụ khác trước khi widget bị hủy
    socket.disconnect();
    super.dispose();
  }
}
