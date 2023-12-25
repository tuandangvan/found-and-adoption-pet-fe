import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/screens/animal_detail_screen.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/place_auto_complete.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/services/center/petApi.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:hive/hive.dart';

// class Filter {
//   String searchKeyword;
//   String petType;
//   String breed; // Thêm thuộc tính breed

//   Filter(
//       {required this.searchKeyword,
//       required this.petType,
//       required this.breed});
// }

class AdoptionScreen extends StatefulWidget {
  final centerId;
  const AdoptionScreen({super.key, required this.centerId});

  @override
  State<AdoptionScreen> createState() => _AdoptionScreenState();
}

class _AdoptionScreenState extends State<AdoptionScreen> {
  //
  late List<Pet> animals = [];
  var centerId;
  late var currentClient;
  bool isLoading = true;
  String selectedPetType = '';

  List<String> animalTypes = [
    'Cat',
    'Dog',
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

  Widget buildAnimalIcon(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _searchController.clear();
                selectedPetType = animalTypes[index];
                _performSearch(); // Gọi hàm tìm kiếm khi loại thú cưng được thay đổi
              });
            },
            child: Material(
              color: selectedPetType == animalTypes[index]
                  ? Theme.of(context).primaryColor
                  : Colors.white,
              elevation: 8,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Icon(
                  animalIcons[index],
                  size: 30,
                  color: selectedPetType == animalTypes[index]
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

  //SEARCH AND FILTER
  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';
  // final Filter _filter = Filter(searchKeyword: '', petType: '', breed: '');

  List<Pet> _searchResults = []; // Danh sách kết quả tìm kiếm

  @override
  void initState() {
    super.initState();
    centerId = widget.centerId;
    getClient() as dynamic;
    _searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    setState(() {
      // _searchResults = animals
      //     .where((pet) =>
      //         // pet.breed.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
      //         pet.petType == selectedPetType)
      //     .toList();

      if (selectedPetType != '') {
        _searchResults =
            animals.where((pet) => pet.petType == selectedPetType).toList();
      } else {
        _searchResults = animals
            .where((pet) =>
                pet.breed.toLowerCase().contains(_searchKeyword.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> getClient() async {
    var temp = await getCurrentClient();
    setState(() {
      currentClient = temp;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      body: isLoading
      ?CircularProgressIndicator()
      :Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: const Icon(
                      FontAwesomeIcons.bars,
                      size: 25,
                      color: Color.fromRGBO(48, 96, 96, 1.0),
                    ),
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
                              ),
                            ),
                          );
                        } else if (currentClient.role == 'CENTER') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenuFrameCenter(
                                centerId: currentClient.id,
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Location  ',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.4),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            // Icon(
                            //   FontAwesomeIcons.mapMarkerAlt,
                            //   color: Theme.of(context).primaryColor,
                            //   size: 15,
                            // ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  currentClient.address.split(',').length > 2
                                      ? currentClient.address
                                          .split(',')
                                          .sublist(currentClient.address
                                                  .split(',')
                                                  .length -
                                              2)
                                          .join(',')
                                      : currentClient.address,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(currentClient.avatar),
                  ),
                ],
              ),
            ),

            //SEARCH
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Theme.of(context).primaryColor.withOpacity(0.06),
                  ),
                  height: 300,
                  child: Column(
                    children: [
                      buildSearchBar(),
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
                      buildAnimalAdopt(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
      );

  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(
              FontAwesomeIcons.search,
              color: Colors.grey,
            ),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Search pet to adopt',
                ),
                onChanged: (value) {
                  if (_searchKeyword != value) {
                    setState(() {
                      selectedPetType = '';
                      _searchKeyword = value;
                    });

                    _performSearch();
                  }
                },
              ),
            ),
            Icon(
              FontAwesomeIcons.filter,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAnimalAdopt() {
    return FutureBuilder<List<Pet>>(
      future: getAllPet(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          animals = snapshot.data ?? [];
          return buildAnimalList(animals);
        }
      },
    );
  }

  Widget fieldInforPet(String infor, String inforDetail) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$infor: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          TextSpan(
            text: '$inforDetail',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAnimalList(List<Pet> animals) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: _searchKeyword.isEmpty && selectedPetType == ''
            ? animals.length
            : _searchResults.length,
        itemBuilder: (context, index) {
          final animal = _searchKeyword.isEmpty && selectedPetType == ''
              ? animals[index]
              : _searchResults[index];

          // Biến tạm thời để giữ giá trị khoảng cách
          String distanceString = '';

          // Gọi hàm tính khoảng cách và gán giá trị vào biến tạm thời
          calculateDistance(currentClient.address, animal.centerId!.address)
              .then((value) {
            distanceString = value.toStringAsFixed(2);
            // Bảo đảm cập nhật lại widget khi giá trị thay đổi
          });

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AnimalDetailScreen(
                      animal: animal,
                      currentId: currentClient,
                    );
                  },
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 28, right: 10, left: 20),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(20),
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: deviceWidth * 0.4),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Text(
                                    //   'Name: ${animal.namePet}',
                                    //   style: TextStyle(
                                    //     fontSize: 16,
                                    //     color: Theme.of(context).primaryColor,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
                                    fieldInforPet('Name', animal.namePet),

                                    Icon(
                                      animal.gender == "FEMALE"
                                          ? FontAwesomeIcons.venus
                                          : FontAwesomeIcons.mars,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Text(
                                //   'Breed: ${animal.breed}',
                                //   style: TextStyle(
                                //     fontSize: 14,
                                //     color: Theme.of(context).primaryColor,
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                // ),
                                fieldInforPet('Breed', animal.breed),
                                const SizedBox(height: 10),
                                // Text(
                                //   'Age: ${animal.age} years old',
                                //   style: const TextStyle(
                                //     color: Colors.grey,
                                //     fontWeight: FontWeight.w600,
                                //   ),
                                // ),
                                fieldInforPet(
                                    'Age', '${animal.age * 12} months'),
                                const SizedBox(height: 10),

                                Row(
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.mapMarkerAlt,
                                      color: Theme.of(context).primaryColor,
                                      size: 16.0,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Distance: ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      // distanceString,
                                      '4.3 km',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w400,
                                      ),
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Hero(
                          tag: animal.namePet,
                          child: Image(
                            image: NetworkImage(animal.images.first),
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
        },
      ),
    );
  }

  //tính toán khoảng cách
  Future<double> calculateDistance(
      String currentAddress, String otherAddress) async {
    LatLng currentP = await convertAddressToLatLng(currentAddress);
    LatLng pDestination = await convertAddressToLatLng(otherAddress);
    double distance = Geolocator.distanceBetween(
      currentP.latitude,
      currentP.longitude,
      pDestination.latitude,
      pDestination.longitude,
    );
    return distance / 1000;
  }
}
