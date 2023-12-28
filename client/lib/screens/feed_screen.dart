// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:found_adoption_application/custom_widget/post_card.dart';
// import 'package:found_adoption_application/models/post.dart';
// import 'package:found_adoption_application/screens/new_post_screen.dart';
// import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
// import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
// import 'package:found_adoption_application/services/post/post.dart';
// import 'package:found_adoption_application/utils/getCurrentClient.dart';

// class FeedScreen extends StatefulWidget {
//   const FeedScreen({super.key});

//   @override
//   State<FeedScreen> createState() => _FeedScreenState();
// }

// class _FeedScreenState extends State<FeedScreen> {
//   Future<List<Post>>? posts;

//   @override
//   void initState() {
//     super.initState();
//     posts = getAllPost();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           title: const Text(
//             'Pet stories',
//             style:
//                 TextStyle(color: Color.fromRGBO(48, 96, 96, 1.0),fontWeight: FontWeight.bold, fontSize: 26),
//           ),
//           leading: IconButton(
//             onPressed: () async {
//               var currentClient = await getCurrentClient();

//               if (currentClient != null) {
//                 if (currentClient.role == 'USER') {
//                   // ignore: use_build_context_synchronously
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => MenuFrameUser(
//                               userId: currentClient.id,
//                             )),
//                   );
//                 } else if (currentClient.role == 'CENTER') {
//                   // ignore: use_build_context_synchronously
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) =>
//                             MenuFrameCenter(centerId: currentClient.id)),
//                   );
//                 }
//               }
//             },
//             icon: const Icon(
//               FontAwesomeIcons.bars,
//               size: 25,
//               color: Color.fromRGBO(48, 96, 96, 1.0),
//             ),
//           ),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => NewPostScreen()));
//               },
//               icon: const Icon(
//                 Icons.add_circle,
//                 size: 30,
//                 color: Color.fromRGBO(48, 96, 96, 1.0),
//               ),
//             ),
//           ],
//         ),
//         body: RefreshIndicator(
//           onRefresh: _refresh,
//           child: FutureBuilder<List<Post>>(
//             future: posts,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               } else if (snapshot.hasError) {
//                 return const Center(child: Text('Please try again later'));
//               } else {
//                 List<Post>? postList = snapshot.data;

//                 if (postList != null) {
//                   return ListView.builder(
//                     itemCount: postList.length,
//                     itemBuilder: (context, index) =>
//                         PostCard(snap: postList[index]),
//                   );
//                 } else {
//                   // Xử lý trường hợp postList là null
//                   return const Scaffold(
//                     body: Center(
//                       child: Icon(
//                         Icons.cloud_off, // Thay thế bằng icon bạn muốn sử dụng
//                         size: 48.0,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   );
//                 }
//               }
//             },
//           ),
//         ));
//   }

//   Future<void> _refresh() async {
//     await Future.delayed(Duration(seconds: 2));
//     setState(() {
//       posts = getAllPost();
//     });
//   }
// }

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/custom_widget/post_card.dart';
import 'package:found_adoption_application/models/post.dart';
import 'package:found_adoption_application/screens/new_post_screen.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/services/post/post.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Post> allPosts = [];
  List<Post> visiblePosts = [];

  int itemsPerPage = 3;
  int currentPage = 0;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      setState(() {
        isLoading = true;
      });

      List<Post> newPosts = await getAllPost();

      setState(() {
        allPosts.addAll(newPosts);
        _loadVisiblePosts();
        isLoading = false;
      });
    } catch (e) {
      print('Error loading posts: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _loadVisiblePosts() {
    int start = currentPage * itemsPerPage;
    int end = start + itemsPerPage;

    if (end > allPosts.length) {
      end = allPosts.length;
    }

    if (start < allPosts.length) {
      visiblePosts.addAll(allPosts.sublist(start, end));
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      allPosts.clear();
      currentPage = 0;
      _loadPosts();
    });
  }

  Future<void> _loadMoreItems() async {
    if (!isLoading) {
      setState(() {
        currentPage++;
        _loadVisiblePosts();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Pet stories',
          style: TextStyle(
              color: Color.fromRGBO(48, 96, 96, 1.0),
              fontWeight: FontWeight.bold,
              fontSize: 26),
        ),
        leading: IconButton(
          onPressed: () async {
            var currentClient = await getCurrentClient();

            if (currentClient != null) {
              if (currentClient.role == 'USER') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuFrameUser(
                      userId: currentClient.id,
                    ),
                  ),
                );
              } else if (currentClient.role == 'CENTER') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MenuFrameCenter(centerId: currentClient.id),
                  ),
                );
              }
            }
          },
          icon: const Icon(
            FontAwesomeIcons.bars,
            size: 25,
            color: Color.fromRGBO(48, 96, 96, 1.0),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewPostScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.add_circle,
              size: 30,
              color: Color.fromRGBO(48, 96, 96, 1.0),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo is ScrollEndNotification &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              _loadMoreItems();
            }
            return true;
          },
          child: ListView.builder(
            itemCount: visiblePosts.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < visiblePosts.length) {
                return PostCard(snap: visiblePosts[index]);
              } else if (isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Container(); // Hiển thị một widget trống khi không có thêm dữ liệu
              }
            },
          ),
        ),
      ),
    );
  }
}
