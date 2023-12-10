import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/models/userInfo.dart';
import 'package:found_adoption_application/services/adopt/adopt.dart';
import 'package:found_adoption_application/services/user/profile_api.dart';

class AnimalDetailScreen extends StatefulWidget {
  final Pet animal;
  final dynamic currentId;

  const AnimalDetailScreen(
      {super.key, required this.animal, required this.currentId});

  @override
  State<AnimalDetailScreen> createState() => _AnimalDetailScreenState();
}

class _AnimalDetailScreenState extends State<AnimalDetailScreen> {
  int currentIndex = 0;
  dynamic currentClient;
  late InfoUser? ownerUser;

  final CarouselController carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    currentClient = widget.currentId;
    ownerUser = InfoUser(
        id: '',
        accountId: '',
        email: '',
        role: '',
        status: '',
        firstName: '',
        lastName: '',
        avatar: '',
        phoneNumber: '',
        address: '',
        experience: true,
        aboutMe: '',
        createdAt: '',
        updatedAt: '');

    if (widget.animal.statusAdopt == 'HAS_ONE_OWNER') {
      ownerUser =
          getProfile(context, widget.animal.foundOwner!.id) as InfoUser?;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    child: widget.animal.images.length == 1
                        ? Hero(
                            tag: widget.animal.namePet,
                            child: Image(
                              height: screenHeight * 0.5,
                              width: double.infinity,
                              image: NetworkImage(widget.animal.images.first),
                              fit: BoxFit.cover,
                            ),
                          )
                        : _slider(widget.animal.images),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            FontAwesomeIcons.arrowLeft,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Icon(
                          CupertinoIcons.share,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              //Nửa giao diện ở dưới(bắt đầu chứa content của user)
              Expanded(
                  child: Container(
                color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(
                                '${ownerUser!.id != '' ? ownerUser!.avatar : widget.animal.centerId!.avatar}'),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    ownerUser!.id != ''
                                        ? "${ownerUser!.firstName + ' ' + ownerUser!.lastName}"
                                        : widget.animal.centerId!.name,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    softWrap: true,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'May 25, 2019',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.animal.description.toString(),
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),
              )),
              currentClient.role == "USER"
                  ? Container(
                      height: 90,
                      decoration: BoxDecoration(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.06),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Material(
                              borderRadius: BorderRadius.circular(20),
                              elevation: 4,
                              color: Theme.of(context).primaryColor,
                              child: const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Icon(
                                  FontAwesomeIcons.heart,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 24,
                            ),
                            widget.animal.statusAdopt != 'HAS_ONE_OWNER'
                                ? Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        showInfoInputDialog(
                                            context, widget.animal.id);
                                      },
                                      child: Material(
                                        borderRadius: BorderRadius.circular(20),
                                        elevation: 4,
                                        color: Theme.of(context).primaryColor,
                                        child: const Padding(
                                          padding: EdgeInsets.all(20.0),
                                          child: Text(
                                            'Adoption',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),

          //THÔNG TIN PET

          Padding(
            padding: const EdgeInsets.all(3),
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                width: MediaQuery.of(context).size.width * 0.7,

                // height: 170,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.animal.namePet,
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(widget.animal.gender == 'FEMALE'
                            ? FontAwesomeIcons.venus
                            : FontAwesomeIcons.mars),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.animal.breed,
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${widget.animal.age} years old',
                          style: const TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Icon(
                          FontAwesomeIcons.mapMarkerAlt,
                          color: Theme.of(context).primaryColor,
                          size: 15,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Expanded(
                          child: Text(
                            widget.animal.centerId!.address,
                            style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w400),

                            softWrap:
                                true, // Để cho phép văn bản xuống dòng khi quá dài
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showInfoInputDialog(BuildContext context, String id) {
    TextEditingController infoController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Description'),
          content: TextField(
            controller: infoController,
            decoration: const InputDecoration(hintText: 'Description'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await createAdopt(
                    widget.animal.id, infoController.text.toString());
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child: const Text('Adopt'),
            ),
          ],
        );
      },
    );
  }

  //sử dụng slider
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
