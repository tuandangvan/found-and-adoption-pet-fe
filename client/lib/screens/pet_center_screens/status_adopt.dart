import 'package:flutter/material.dart';
import 'package:found_adoption_application/screens/pet_center_screens/menu_frame_center.dart';
import 'package:found_adoption_application/screens/user_screens/menu_frame_user.dart';
import 'package:found_adoption_application/utils/getCurrentClient.dart';

class StatusAdopt extends StatefulWidget {
  @override
  _StatusAdoptState createState() => _StatusAdoptState();
}

class _StatusAdoptState extends State<StatusAdopt>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        ),
        title: Text(
          'Adoption Page',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w800,
            color: Color.fromRGBO(48, 96, 96, 1.0),
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
          AdoptionTabView(status: 'Pending'),
          AdoptionTabView(status: 'Accept'),
          AdoptionTabView(status: 'Cancel'),
        ],
      ),
    );
  }
}

class AdoptionTabView extends StatelessWidget {
  final String status;

  AdoptionTabView({required this.status});

  Widget _buildAdoptionRequestCard(
      String userName, String petName, String description) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin người dùng
            // Thông tin người dùng
            Row(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: AssetImage(
                      'assets/images/Lan.jpg'), // Đường dẫn ảnh đại diện của người dùng
                ),
                SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$userName',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(48, 96, 96, 1.0),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16.0,
                          color: Color.fromRGBO(48, 96, 96, 1.0),
                        ),
                        Text(
                          '14/34 Lê Văn Chí Thủ Đức', // Thay đổi bằng biến chứa địa chỉ của người dùng
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
                      Row(
                        children: [
                          Icon(
                            Icons.mail,
                            size: 16.0,
                            color: Color.fromRGBO(48, 96, 96, 1.0),
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            'mylan060401@gmail.com', // Thay đổi bằng biến chứa địa chỉ email của người dùng
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Color.fromRGBO(48, 96, 96, 1.0),
                            ),
                          ),
                          SizedBox(width: 16.0),
                        ],
                      ), // Khoảng cách giữa email và số điện thoại
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 16.0,
                            color: Color.fromRGBO(48, 96, 96, 1.0),
                          ),
                          SizedBox(width: 4.0),
                          Text(
                            '0799353524', // Thay đổi bằng biến chứa số điện thoại của người dùng
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
                        text: petName,
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

            // Ảnh thú cưng
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/images/cat_ava.png', // Đường dẫn ảnh thú cưng
                width: double.infinity,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),

            // lời nhắn
            Container(
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
                      description,
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
                  ElevatedButton(
                    onPressed: () {
                      // Xử lý khi nhấn nút Accept
                    },
                    child: Text(
                      'Accept',
                      style: TextStyle(
                        fontSize: 17,
                        color: Color.fromRGBO(48, 96, 96, 1.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Xử lý khi nhấn nút Cancel
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 17,
                        color: Color.fromRGBO(48, 96, 96, 1.0),
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
    List<String> userNames = ['UserA', 'UserB', 'UserC'];
    List<String> petNames = ['PetA', 'PetB', 'PetC'];
    List<String> descriptions = [
      'Tôi rất yêu mèo, tôi có kinh nghiệm về chăm sóc giống mèo này, tôi chắc chắc sẽ là 1 new owner tốt',
      'Chó mèo cũng là con người. Thật tốt khi cho chúng 1 mái ấm tốt hơn.',
      'Để tui nuôi cho, tui có nhiều tiền lắm =))'
    ];

    return ListView.builder(
      itemCount: userNames.length,
      itemBuilder: (context, index) {
        return _buildAdoptionRequestCard(
            userNames[index], petNames[index], descriptions[index]);
      },
    );
  }
}
