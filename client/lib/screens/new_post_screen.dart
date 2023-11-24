import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:found_adoption_application/repository/add_post_api.dart';
import 'package:found_adoption_application/repository/multi_image_api.dart';

import 'package:found_adoption_application/screens/feed_screen.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  int currentIndex = 0;
  final CarouselController carouselController = CarouselController();

  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];

  List<dynamic> finalResult = [];

  final TextEditingController _captionController = TextEditingController();
  var avatar = '';

  Future<List<dynamic>> selectImage() async {
    List<dynamic> finalResult2 = [];

    final List<XFile> selectedImages = await imagePicker.pickMultiImage();

    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }

    var result = await uploadMultiImage(imageFileList);
    finalResult2 = result.map((url) => url).toList();

    // print('test selectedImage: $finalResult');
    print('test selectedImage: $finalResult2');

    // Check if the widget is still mounted before calling setState
    if (mounted) {
      setState(() {
        finalResult = finalResult2;
      });
    }

    return finalResult2;
  }

  Future<void> _post() async {
    // Example: Print the caption and reset the state
    print('Caption: ${_captionController.text}');
    var finalResult =
        await selectImage(); // Sử dụng await để đợi giá trị trả về từ Future
    print('test images here: $finalResult');

    // Kiểm tra trạng thái mounted trước khi gọi setState
    if (mounted) {
      // Call the API to post content with image paths
      addPost(_captionController.text.toString(), finalResult);

      setState(() {
        _captionController.clear();
      });
    }
  }

  Future<void> openHiveBox() async {
    var avatar2 = '';
    var userBox = await Hive.openBox('userBox');
    var centerBox = await Hive.openBox('centerBox');

    var currentUser = userBox.get('currentUser');
    var currentCenter = centerBox.get('currentCenter');

    avatar2 = currentUser != null ? currentUser.avatar : currentCenter.avatar;
    print('test avatar2: $avatar2');

    setState(() {
      avatar = avatar2;
    });

    print('test avatar in openHiveBox: $avatar');
  }

  @override
  void initState() {
    super.initState();
    openHiveBox();
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted) {
      return Container(); // Return an empty container if widget is disposed
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(width: 4, color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.1),
                        )
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(avatar),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  const Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      await _post();
                    },
                    child: const Text(
                      'Post',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _captionController,
                decoration: InputDecoration(
                  hintText: 'Write a caption...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
                maxLines: 2,
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
              // imageFileList.isNotEmpty
              //     ?
              //     _slider(finalResult)
              //     // ? Column()
              //     : Container(
              //         height: 350.0,
              //         width: double.infinity,
              //         color: Colors.grey.shade300,
              //         child: Center(
              //           child: IconButton(
              //             icon: Icon(Icons.camera_alt),
              //             onPressed: selectImage,
              //           ),
              //         ),
              //       ),

              // Conditionally render the image widget
              if (imageFileList.isNotEmpty)
                if (imageFileList.length == 1)
                  Image.file(
                    File(imageFileList[0].path),
                    height: 350.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                else
                  _slider(finalResult)
              else
                Container(
                  height: 350.0,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: selectImage,
                    ),
                  ),
                ),

              const SizedBox(height: 50),
              MaterialButton(
                minWidth: double.infinity,
                height: 50,
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FeedScreen()),
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Cancel timers or stop animations here
    super.dispose();
  }

  Widget _slider(List imageList) {
    return Stack(
      children: [
        CarouselSlider(
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
            //điều chỉnh tỉ lệ ảnh hiển thị
            aspectRatio: 20 / 20,
            viewportFraction: 1,

            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),

        //cấu hình nút chạy ảnh
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
