import 'dart:ffi';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/pet_center.dart';
import 'package:found_adoption_application/models/post.dart';
import 'package:found_adoption_application/models/user.dart';
import 'package:found_adoption_application/repository/get_all_post_api.dart';
import 'package:hive/hive.dart';

class PostCard extends StatefulWidget {
  final snap;
  PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final clientPost = widget.snap!;

    return Card(
      color: Colors.white,
      elevation: 5,
      margin: EdgeInsets.only(left: 0, top: 0, bottom: 1),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                const SizedBox(
                  height: 5,
                ),
                CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                      clientPost.userId != null
                          ? '${clientPost.userId!.avatar}'
                          : '${clientPost.petCenterId.avatar}',
                    )),
                const SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clientPost.userId != null
                              ? '${clientPost.userId!.firstName} ${clientPost.userId!.lastName}'
                              : clientPost.petCenterId.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),

                        //Thời gian đăng bài
                        Text(
                          'Posted on 10/10/2023',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      print('test images: ${clientPost.images}');

                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                child: ListView(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  //widget co lại dựa theo nội dung
                                  shrinkWrap: true,
                                  //sử dụng map để tạo ra ds các InkWell(hiệu ứng khi nhấp button)
                                  children: ['Delete']
                                      .map(
                                        (e) => InkWell(
                                            onTap: () {},
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                      horizontal: 12),
                                              child: Text(e),
                                            )),
                                      )
                                      .toList(),
                                ),
                              ));
                    },
                    icon: const Icon(Icons.more_vert)),
              ],
            ),
          ),
          SizedBox(
            height: 4,
          ),

          //IMAGE SECTION

          clientPost.images != null && clientPost.images.isNotEmpty
              ? _slider(clientPost.images)
              : const SizedBox(),

          //LIKE+COMMENT SECTION
          Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  )),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.comment_outlined)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
            ],
          ),

          //DESCRIPTION & NUMBER OF COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1,234 likes',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                      text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: [
                        TextSpan(
                          // text: clientPost.petCenterId!.name,
                          text: clientPost.userId != null
                              ? '${clientPost.userId!.firstName} ${clientPost.userId!.lastName}'
                              : clientPost.petCenterId
                                  .name, // Xử lý trường hợp khác nếu cần thiết
                          // '${snapshot.data!.userId.firstName} ${snapshot.data!.userId.lastName}    ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: clientPost.content,
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        )
                      ])),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    child: Text(
                      'View all 200 comments',
                      style: const TextStyle(fontSize: 15, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _slider(List imageList) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            print(currentIndex);
          },
          child: CarouselSlider(
            items: imageList
                .map(
                  (item) => Image.network(
                    item,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                )
                .toList(),
            carouselController: carouselController,
            options: CarouselOptions(
              scrollPhysics: const BouncingScrollPhysics(),
              autoPlay: true,
              aspectRatio: 2,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imageList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => carouselController.animateToPage(entry.key),
                child: Container(
                  width: currentIndex == entry.key ? 17 : 7,
                  height: 7.0,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 3.0,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          currentIndex == entry.key ? Colors.red : Colors.teal),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
