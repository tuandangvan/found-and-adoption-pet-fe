import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/screens/pet_center_screens/edit_pet_screen.dart';
import 'package:found_adoption_application/services/adopt/adopt.dart';
import 'package:found_adoption_application/services/center/petApi.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';
import 'package:intl/intl.dart';

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

  final CarouselController carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    currentClient = widget.currentId;
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
                            Icons.arrow_back_ios,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        currentClient.role == 'CENTER'
                            ? PopupMenuButton<String>(
                                color: Colors.white,
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onSelected: (String choice) {
                                  // Handle menu item selection
                                  if (choice == 'edit') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditPetScreen(pet: widget.animal),
                                      ),
                                    );
                                  } else if (choice == 'delete') {
                                    _showDeleteConfirmationDialog(widget.animal.id);
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),

              //Nửa giao diện ở dưới(bắt đầu chứa content của user)
              currentClient.role == 'CENTER'
                  ? Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: Container(
                        // height: MediaQuery.sizeOf(context).height * 0.45,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 30.0,
                                    backgroundImage: NetworkImage(
                                      widget.animal.statusAdopt ==
                                              'HAS_ONE_OWNER'
                                          ? widget.animal.foundOwner!.avatar
                                          : widget.animal.centerId!.avatar,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            widget.animal.statusAdopt ==
                                                    'HAS_ONE_OWNER'
                                                ? '${widget.animal.foundOwner!.firstName} ${widget.animal.foundOwner!.lastName}'
                                                : widget.animal.centerId!.name,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            softWrap: true,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            DateFormat.yMMMMd()
                                                .add_Hms()
                                                .format(
                                                    widget.animal.createdAt!),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                widget.animal.description.toString(),
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 45),
                      child: Container(
                        // height: MediaQuery.sizeOf(context).height * 0.45,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 30.0,
                                    backgroundImage: NetworkImage(
                                      widget.animal.statusAdopt ==
                                              'HAS_ONE_OWNER'
                                          ? widget.animal.foundOwner!.avatar
                                          : widget.animal.centerId!.avatar,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            widget.animal.statusAdopt ==
                                                    'HAS_ONE_OWNER'
                                                ? '${widget.animal.foundOwner!.firstName} ${widget.animal.foundOwner!.lastName}'
                                                : widget.animal.centerId!.name,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            softWrap: true,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            DateFormat.yMMMMd()
                                                .add_Hms()
                                                .format(
                                                    widget.animal.createdAt!),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                widget.animal.description.toString(),
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),

                              //Button Adoption
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                        width: 15,
                                      ),
                                      widget.animal.statusAdopt !=
                                              'HAS_ONE_OWNER'
                                          ? Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  showInfoInputDialog(context,
                                                      widget.animal.id);
                                                },
                                                child: Material(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  elevation: 4,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  child: const Padding(
                                                    padding:
                                                        EdgeInsets.all(20.0),
                                                    child: Text(
                                                      'Adoption',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox(
                                              height: 0,
                                            ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
              // currentClient.role == "USER"
              //     ? Container(
              //         height: 5,
              //         decoration: BoxDecoration(
              //             color:
              //                 Theme.of(context).primaryColor.withOpacity(0.06),
              //             borderRadius: const BorderRadius.only(
              //               topRight: Radius.circular(30),
              //               topLeft: Radius.circular(30),
              //             )),
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(horizontal: 22),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Material(
              //                 borderRadius: BorderRadius.circular(20),
              //                 elevation: 4,
              //                 color: Theme.of(context).primaryColor,
              //                 child: const Padding(
              //                   padding: EdgeInsets.all(20.0),
              //                   child: Icon(
              //                     FontAwesomeIcons.heart,
              //                     color: Colors.white,
              //                   ),
              //                 ),
              //               ),
              //               const SizedBox(
              //                 height: 0,
              //               ),
              //               widget.animal.statusAdopt != 'HAS_ONE_OWNER'
              //                   ? Expanded(
              //                       child: GestureDetector(
              //                         onTap: () {
              //                           showInfoInputDialog(
              //                               context, widget.animal.id);
              //                         },
              //                         child: Material(
              //                           borderRadius: BorderRadius.circular(20),
              //                           elevation: 4,
              //                           color: Theme.of(context).primaryColor,
              //                           child: const Padding(
              //                             padding: EdgeInsets.all(20.0),
              //                             child: Text(
              //                               'Adoption',
              //                               style: TextStyle(
              //                                   color: Colors.white,
              //                                   fontWeight: FontWeight.bold,
              //                                   fontSize: 18),
              //                               textAlign: TextAlign.center,
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //                     )
              //                   : const SizedBox(
              //                       height: 0,
              //                     ),
              //               const SizedBox(
              //                 width: 10,
              //               ),
              //             ],
              //           ),
              //         ),
              //       )
              //     : const SizedBox(),
              // currentClient.role == 'CENTER'
              //     ? Expanded(
              //         flex: 1,
              //         child: GestureDetector(
              //           onTap: () {
              //             Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (context) =>
              //                         EditPetScreen(pet: widget.animal)));
              //           },
              //           child: Material(
              //             borderRadius: BorderRadius.circular(20),
              //             elevation: 4,
              //             color: Theme.of(context).primaryColor,
              //             child: const Padding(
              //               padding: EdgeInsets.all(20.0),
              //               child: Text(
              //                 'Edit pet',
              //                 style: TextStyle(
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 18),
              //                 textAlign: TextAlign.center,
              //               ),
              //             ),
              //           ),
              //         ),
              //       )
              //     : const SizedBox(
              //         height: 0,
              //       ),
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
                        const SizedBox(
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
                if(infoController.text.toString().isEmpty){
                  notification('Description not empty!', true);
                  return;
                }
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

  Future<void> _showDeleteConfirmationDialog(String petId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this pet?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await deletePet(petId);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
