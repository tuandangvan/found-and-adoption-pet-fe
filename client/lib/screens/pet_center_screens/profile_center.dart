import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:found_adoption_application/custom_widget/post_card.dart';
import 'package:found_adoption_application/models/pet.dart';
import 'package:found_adoption_application/models/post.dart';
import 'package:found_adoption_application/models/userCenter.dart';
import 'package:found_adoption_application/screens/animal_detail_screen.dart';
import 'package:found_adoption_application/screens/pet_center_screens/edit_profile_center.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/services/center/petApi.dart';
import 'package:found_adoption_application/services/post/post.dart';
import 'package:found_adoption_application/services/user/profile_api.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileCenterPage extends StatefulWidget {
  final centerId;
  ProfileCenterPage({super.key, required this.centerId});

  @override
  State<ProfileCenterPage> createState() => _ProfileCenterPageState();
}

class _ProfileCenterPageState extends State<ProfileCenterPage> {
  int selectedAnimalIconIndex = 0;
  Future<List<Post>>? petStoriesPosts;
  late Future<InfoCenter> centerFuture;
  late Future<List<Pet>> petsFuture;
  late List<Pet> animals = [];
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
    petStoriesPosts = getAllPostPersonal(widget.centerId);
    centerFuture = getProfileCenter(context, widget.centerId);
    petsFuture = getAllPetOfCenter(widget.centerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () async {
            var currentClient = await getCurrentClient();

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
          color: Theme.of(context).primaryColor,
        ),
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Sử dụng TypewriterAnimatedTextKit để tạo hiệu ứng chữ chạy
            TypewriterAnimatedTextKit(
              speed: Duration(milliseconds: 200),
              totalRepeatCount: 1, // Số lần lặp (1 lần để chạy từ đầu đến cuối)
              text: ['Profile'],
              textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<InfoCenter>(
          future: centerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // If the Future is still loading, show a loading indicator
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // If there is an error fetching data, show an error message
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // If data is successfully fetched, display the form
              InfoCenter center = snapshot.data!;
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ảnh đại diện
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Avatar
                        InkWell(
                          onTap: () {
                            _showFullScreenImage(context, center.avatar);
                          },
                          child: Hero(
                            tag: 'avatarTag',
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundImage: NetworkImage('${center.avatar}'),
                            ),
                          ),
                        ),
                        // Nút Follow và Edit Profile
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                // Xử lý khi nhấn nút Follow
                              },
                              icon: Icon(Icons.person_add, color: Colors.white),
                              label: Text('Follow'),
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context)
                                    .primaryColor, // Đổi màu nền của nút
                                onPrimary:
                                    Colors.white, // Đổi màu văn bản của nút
                              ),
                            ),
                            SizedBox(width: 8.0),
                            // currentClient.id == widget.userId
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const EditProfileCenterScreen()));
                              },
                              icon: Icon(Icons.edit, color: Colors.white),
                              label: Text('Edit profile'),
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                onPrimary: Colors.white,
                              ),
                            )
                            // : SizedBox(width: 5.0),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),

                    // Họ và Tên
                    Text(
                      '${center.name}',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),

                    // Contact me
                    buildSectionHeader('Contact center', Icons.mail),
                    buildContactInfo(center.phoneNumber, Icons.phone, 'phone'),
                    buildContactInfo(center.email, Icons.email, 'email'),
                    buildContactInfo(center.address,
                        IconData(0xe3ab, fontFamily: 'MaterialIcons'), ''),
                    SizedBox(height: 16.0),

                    // About me
                    buildSectionHeader('About center', Icons.info),
                    buildInfo(center.aboutMe),
                    SizedBox(height: 16.0),

                    // Experience
                    // buildSectionHeader('Experience', Icons.work),
                    // buildInfo(
                    //     'Y tế rất nà xịn xò nhé. Khó khăn cứ alo trung tâm...hí hí'),
                    SizedBox(height: 16.0),

                    Container(
                      width: double.infinity,
                      height: 8.0,
                      color: const Color.fromARGB(255, 176, 175, 175),
                      margin: EdgeInsets.symmetric(vertical: 16.0),
                    ),

                    // List các bài viết đã đăng
                    buildSectionHeader('Articles posted', Icons.library_books),

                    // Widget chứa TabBar và TabBarView
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          // TabBar để chọn giữa "Pet Stories" và "Pet Adoption"
                          TabBar(
                            labelColor: Theme.of(context).primaryColor,
                            tabs: [
                              Tab(text: 'Pet Stories'),
                              Tab(text: 'Pet Adoption'),
                            ],
                          ),
                          // TabBarView để hiển thị nội dung tương ứng với từng tab
                          SizedBox(
                            height:
                                500, // Thay đổi kích thước này tùy theo nhu cầu của bạn
                            child: TabBarView(
                              children: [
                                // Nội dung cho tab "Pet Stories"
                                buildPostsList(petStoriesPosts!),
                                // Nội dung cho tab "Pet Adoption"
                                buildAdoptionList(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }

  // Widget hiển thị danh sách bài đăng
  Widget buildPostsList(Future<List<Post>>? posts) {
    return FutureBuilder<List<Post>>(
        future: posts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Post>? postList = snapshot.data;
            if (postList != null) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: postList.length,
                itemBuilder: (context, index) =>
                    PostCard(snap: postList[index]),
              );
            } else {
              // Xử lý trường hợp postList là null
              return Scaffold(
                body: Center(
                  child: Icon(
                    Icons.cloud_off, // Thay thế bằng icon bạn muốn sử dụng
                    size: 48.0,
                    color: Colors.grey,
                  ),
                ),
              );

              // Text('Post list is null');
            }
          }
        });
  }

  Widget buildAdoptionList() {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              color: Theme.of(context).primaryColor.withOpacity(0.06)),
          height: 500,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Container(
                  width: 500.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: const Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.search,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 14),
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
                height: 80,
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
                child: FutureBuilder<List<Pet>>(
                    future: petsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                      MaterialPageRoute(builder: (context) {
                                    return AnimalDetailScreen(animal: animal);
                                  }));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 23, right: 7, left: 16),
                                  child: Stack(
                                    alignment: Alignment.centerLeft,
                                    children: [
                                      Material(
                                        borderRadius: BorderRadius.circular(20),
                                        elevation: 4.0,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                  width: deviceWidth * 0.4),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          animal.namePet,
                                                          style: TextStyle(
                                                              fontSize: 26,
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
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      animal.breed,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      '${animal.age} years old',
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          FontAwesomeIcons
                                                              .mapMarkerAlt,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          size: 16.0,
                                                        ),
                                                        const SizedBox(
                                                            width: 6),
                                                        Text(
                                                          'Distance: ',
                                                          style: TextStyle(
                                                              fontSize: 15,
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
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
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
    );
  }

  Widget buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24.0, color: Theme.of(context).primaryColor),
        SizedBox(width: 8.0),
        Text(
          title,
          style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ),
      ],
    );
  }

  Widget buildContactInfo(String info, IconData icon, String type) {
    return InkWell(
      onLongPress: () {
        _copyToClipboard(info);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Copied to Clipboard: $info'),
          ),
        );
      },
      onTap: () {
        if (type == 'email') {
          launchEmail(info);
        } else if (type == 'phone') {
          makePhoneCall('tel:${info}');
        }
      },
      child: Row(
        children: [
          Icon(icon, size: 16.0),
          SizedBox(width: 8.0),
          Text(
            info,
            style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget buildInfo(String info) {
    return Text(
      info,
      style: TextStyle(fontSize: 16.0),
    );
  }

  // Hàm xử lý khi click vào ảnh avatar để hiển thị ảnh full màn hình
  void _showFullScreenImage(BuildContext context, String image) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Hero(
            tag: 'avatarTag',
            child: Image.network('${image}'), // Thay đổi đường dẫn ảnh
          ),
        ),
      ),
    ));
  }

  // Hàm để mở ứng dụng email với địa chỉ được cung cấp
  void launchEmail(String email) async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunch(_emailLaunchUri.toString())) {
      await launch(_emailLaunchUri.toString());
    } else {
      throw 'Không thể mở ứng dụng email';
    }
  }

  void makePhoneCall(String phoneNumber) async {
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Không thể gọi điện thoại';
    }
  }

  // Hàm để sao chép văn bản vào clipboard
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
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
                padding: const EdgeInsets.all(13),
                child: Icon(
                  animalIcons[index],
                  size: 20,
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
                fontSize: 12,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
