import 'package:flutter/material.dart';
import 'package:found_adoption_application/models/adopt.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/screens/user_screens/profile_user.dart';
import 'package:found_adoption_application/services/adopt/adopt.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';

class StatusAdopt extends StatefulWidget {
  @override
  _StatusAdoptState createState() => _StatusAdoptState();
}

class _StatusAdoptState extends State<StatusAdopt>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Future<List<Adopt>>? adoptsPENFuture;
  Future<List<Adopt>>? adoptsACCFuture;
  Future<List<Adopt>>? adoptsCANFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    adoptsPENFuture = getStatusAdoptCenter("PENDING");
    adoptsACCFuture = getStatusAdoptCenter("ACCEPTED");
    adoptsCANFuture = getStatusAdoptCenter("CANCELLED");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            var currentClient = await getCurrentClient();

            if (currentClient != null) {
              if (currentClient.role == 'USER') {
                // ignore: use_build_context_synchronously
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
        title: Text(
          'Adoption Status',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Pending'),
            Tab(text: 'Accept'),
            Tab(text: 'Cancel'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AdoptionTabView(
            status: 'Pending',
            adoptFuture: adoptsPENFuture,
          ),
          AdoptionTabView(
            status: 'Accept',
            adoptFuture: adoptsACCFuture,
          ),
          AdoptionTabView(
            status: 'Cancel',
            adoptFuture: adoptsCANFuture,
          ),
        ],
      ),
    );
  }
}

class AdoptionTabView extends StatelessWidget {
  final String status;
  final Future<List<Adopt>>? adoptFuture;

  AdoptionTabView({required this.status, required this.adoptFuture});

  Widget _buildAdoptionRequestCard(BuildContext context, Adopt adopt) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                  userId: adopt.userId!
                                      .id) // Thay thế bằng tên lớp tương ứng
                              ));
                    },
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(adopt.userId!.avatar),
                    )),
                SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                      userId: adopt.userId!
                                          .id) // Thay thế bằng tên lớp tương ứng
                                  ));
                        },
                        child: Text(
                          '${adopt.userId!.lastName}',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(48, 96, 96, 1.0),
                          ),
                        )),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16.0,
                          color: Color.fromRGBO(48, 96, 96, 1.0),
                        ),
                        Text(
                          '${adopt.userId!.address}', // Thay đổi bằng biến chứa địa chỉ của người dùng
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Color.fromRGBO(48, 96, 96, 1.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),

            // Thông tin thú cưng
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Phần "Contact"
                Text(
                  'Contact:',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Khoảng cách giữa email và số điện thoại
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 16.0,
                            color: Color.fromRGBO(48, 96, 96, 1.0),
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            '${adopt.userId!.phoneNumber}', // Thay đổi bằng biến chứa số điện thoại của người dùng
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Color.fromRGBO(48, 96, 96, 1.0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 3,
                  width: 3.0,
                ),

                RichText(
                  text: TextSpan(
                    text: 'Requests adopt:   ',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16.0,
                      color: Colors.black, // Màu sắc cho phần "Requests adopt"
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: adopt.petId!.namePet,
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold, // Làm cho petName in đậm
                          color: Color.fromRGBO(
                              48, 96, 96, 1.0), // Màu sắc cho petName
                        ),
                      ),
                    ],
                  ),
                ),

                // Tên thú cưng
              ],
            ),
            SizedBox(
              width: 3.0,
            ),
            // Ảnh thú cưng
            GestureDetector(
                onTap: () {
                  //
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    '${adopt.petId!.images[0]}', // Đường dẫn ảnh thú cưng
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                )),
            SizedBox(
              height: 5.0,
            ),
            // lời nhắn
            Container(
              width: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Color.fromRGBO(48, 96, 96, 1.0), // Màu viền
                  width: 2.0, // Độ dày viền
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 2), // Điều chỉnh độ đổ bóng
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Express Adoption Interest:',
                      style: TextStyle(
                        fontSize: 15.0,

                        fontStyle: FontStyle.italic, // Đặt chữ nghiêng
                        decoration: TextDecoration.underline, // Thêm gạch đít
                        decorationColor: Colors.black, // Màu của gạch đít
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 3.0),
                    Text(
                      adopt.descriptionAdoption.toString(),
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 6.0),

            // Nút Accept và Cancel
            if (status == 'Pending')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.check, color: Colors.white),
                    label: GestureDetector(
                        onTap: () async {
                          await changeStatusAdoptCenter(adopt.id, "ACCEPTED");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      StatusAdopt() // Thay thế bằng tên lớp tương ứng
                                  ));
                        },
                        child: Text('Accept', style: TextStyle(fontSize: 17))),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(48, 96, 96, 1.0),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Điều này sẽ bo góc
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.cancel, color: Colors.white),
                    label: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 17),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(241, 95, 4, 1),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Điều này sẽ bo góc
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Adopt>? adopt;
    return FutureBuilder(
        future: adoptFuture,
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
            adopt = snapshot.data;
            if (adopt!.length > 0) {
              return ListView.builder(
                itemCount: adopt!.length,
                itemBuilder: (context, index) {
                  return _buildAdoptionRequestCard(context, adopt![index]);
                },
              );
            } else {
              return Center(
                child: Icon(
                  Icons.cloud_off, // Thay thế bằng icon bạn muốn sử dụng
                  size: 48.0,
                  color: Colors.grey,
                ),
              );
            }
          }
          return Center();
        });
  }
}
