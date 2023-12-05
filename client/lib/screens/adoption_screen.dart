import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/repository/center_api/get_all_pet.dart';

import 'package:found_adoption_application/screens/animal_detail_screen.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';

import 'package:hive/hive.dart';

class AdoptionScreen extends StatefulWidget {
  final centerId;
  const AdoptionScreen({super.key, required this.centerId});

  @override
  State<AdoptionScreen> createState() => _AdoptionScreenState();
}

class _AdoptionScreenState extends State<AdoptionScreen> {
  int selectedAnimalIconIndex = 0;

  late List<Pet> animals = [];

  late Future<List<Pet>> petsFuture;
  var centerId;

  List<String> animalTypes = [
    'Cats',
    'Dogs',
    'Parrots',
    'Fish',
    'Fish',
  ];

  List<IconData> animalIcons = [
    FontAwesomeIcons.cat,
    FontAwesomeIcons.dog,
    FontAwesomeIcons.crow,
    FontAwesomeIcons.fish,
    FontAwesomeIcons.fish
  ];
  @override
  void initState() {
    super.initState();
    centerId = widget.centerId;
  }

  Widget buildAnimalIcon(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                selectedAnimalIconIndex = index;
              });
            },
            child: Material(
              color: selectedAnimalIconIndex == index
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              elevation: 8,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Icon(
                  animalIcons[index],
                  size: 30,
                  color: selectedAnimalIconIndex == index
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            animalTypes[index],
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  child: Icon(FontAwesomeIcons.bars),
                  onTap: () async {
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
                          MaterialPageRoute(
                              builder: (context) => MenuFrameUser(
                                    userId: currentClient.id,
                                  )),
                        );
                      } else if (currentClient.role == 'CENTER') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MenuFrameCenter(centerId: currentClient.id)),
                        );
                      }
                    }
                  },
                ),
                Column(
                  children: [
                    Text('Location  ',
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: Theme.of(context)
                                .primaryColor
                                .withOpacity(0.4))),
                    Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.mapMarkerAlt,
                          color: Theme.of(context).primaryColor,
                        ),
                        Text('Kyiv, ',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 22)),
                        Text('Ukraine  ',
                            style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 22)),
                      ],
                    )
                  ],
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/Lan.jpg'),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Theme.of(context).primaryColor.withOpacity(0.06)),
                height: 300,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: const Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.search,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: TextField(
                                style: TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    hintText: 'Search pet to adop'),
                              ),
                            ),
                            Icon(
                              FontAwesomeIcons.filter,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),

                    //ANIMATION CÁC LOẠI ĐỘNG VẬT
                    Container(
                      height: 120,
                      child: ListView.builder(
                          padding: EdgeInsets.only(left: 24),
                          scrollDirection: Axis.horizontal,
                          itemCount: animalTypes.length,
                          itemBuilder: (context, index) {
                            return buildAnimalIcon(index);
                          }),
                    ),

                    //CHI TIẾT VỀ THÔNG TIN CÁC PET ĐƯỢC NHẬN NUÔI
                    Expanded(
                      child: FutureBuilder<List<Pet>> (
                          future: getAllPet(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              animals = snapshot.data ?? [];
                              return ListView.builder(
                                  itemCount: animals.length,
                                  itemBuilder: (context, index) {
                                    final animal = animals[index];

                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return AnimalDetailScreen(
                                              animal: animal);
                                        }));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 28, right: 10, left: 20),
                                        child: Stack(
                                          alignment: Alignment.centerLeft,
                                          children: [
                                            Material(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              elevation: 4.0,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                        width:
                                                            deviceWidth * 0.4),
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                animal.namePet,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        26,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Icon(animal.gender ==
                                                                      "FEMALE"
                                                                  ? FontAwesomeIcons
                                                                      .venus
                                                                  : FontAwesomeIcons
                                                                      .mars),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Text(
                                                            animal.breed,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Text(
                                                            '${animal.age} years old',
                                                            style: const TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                          const SizedBox(
                                                              height: 10),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                FontAwesomeIcons
                                                                    .mapMarkerAlt,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                size: 16.0,
                                                              ),
                                                              const SizedBox(
                                                                  width: 6),
                                                              Text(
                                                                'Distance: ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Stack(
                                              alignment: Alignment.centerLeft,
                                              children: [
                                                // ClipRRect(
                                                //   borderRadius:
                                                //       BorderRadius.circular(
                                                //           20), // Bo góc 20 độ
                                                //   child: Container(
                                                //     decoration: BoxDecoration(
                                                //         // color: animal
                                                //         //     .backgroundColor,
                                                //         color: const Color
                                                //             .fromARGB(255, 233,
                                                //             223, 133)),
                                                //     height: 190,
                                                //     width: deviceWidth * 0.4,
                                                //   ),
                                                // ),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20), // Bo góc 20 độ

                                                  /*sử dụng tag để xác định hiệu ứng chuyển tiếp child(Image) 
                                                  ở widget này đến widget khác*/
                                                  child: Hero(
                                                    tag: animal.namePet,
                                                    child: Image(
                                                      image: NetworkImage(
                                                          animal.images.first),
                                                      height: 190,
                                                      width: deviceWidth * 0.4,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
