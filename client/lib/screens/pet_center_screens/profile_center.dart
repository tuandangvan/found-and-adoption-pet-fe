import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileCenterPage extends StatefulWidget {
  @override
  State<ProfileCenterPage> createState() => _ProfileCenterPageState();
}

class Post {
  final String title;
  final String content;

  Post(this.title, this.content);
}

class _ProfileCenterPageState extends State<ProfileCenterPage> {
  List<Post> petStoriesPosts = [
    Post('Chó nhỏ xinh', 'Đây là chó nhỏ xinh đáng yêu.'),
    Post('Mèo dễ thương', 'Mèo này rất dễ thương và đáng yêu.'),
    Post('Chim cút biết hát', 'Chim cút này biết hát rất hay.'),
  ];

  List<Post> petAdoptionPosts = [
    Post('AAAAA', 'bbbbbbbbbbb'),
    Post('VVVVVVVVVVV', 'EEEEEEE'),
    Post('BBBBBBBBBBBB', 'RRRRRRRRRRRR'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Sử dụng TypewriterAnimatedTextKit để tạo hiệu ứng chữ chạy
            TypewriterAnimatedTextKit(
              speed: Duration(milliseconds: 200),
              totalRepeatCount: 1, // Số lần lặp (1 lần để chạy từ đầu đến cuối)
              text: ['Profile'],
              textStyle: TextStyle(
                color: Colors.blue,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ảnh đại diện
            InkWell(
              onTap: () {
                // Hàm xử lý khi click vào ảnh avatar
                _showFullScreenImage(context);
              },
              child: Hero(
                tag: 'avatarTag',
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: AssetImage(
                      'assets/images/dog_banner.png'), // Thay đổi đường dẫn ảnh
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // Họ và Tên
            Text(
              'Center: Trung tâm hỗ trợ Thú Cưng',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),

            // Contact me
            buildSectionHeader('Contact center', Icons.mail),
            buildContactInfo('Số điện thoại: 0123 456 789', Icons.phone),
            buildContactInfo('Email: nguyenvana@gmail.com', Icons.email),
            SizedBox(height: 16.0),

            // About me
            buildSectionHeader('About center', Icons.info),
            buildInfo(
                'Trung tâm đã giúp đỡ rất nhiều thú cưng. Rất mong sự gắn kết của mọi người để tình yêu được lan tỏa.'),
            SizedBox(height: 16.0),

            // Experience
            buildSectionHeader('Experience', Icons.work),
            buildInfo(
                'Y tế rất nà xịn xò nhé. Khó khăn cứ alo trung tâm...hí hí'),
            SizedBox(height: 16.0),

            Container(
              width: double.infinity,
              height: 8.0,
              color: const Color.fromARGB(255, 176, 175, 175),
              margin: EdgeInsets.symmetric(vertical: 16.0),
            ),

            // List các bài viết đã đăng
            // buildSectionHeader('Bài viết đã đăng', Icons.library_books),
            // // Dùng ListView để hiển thị danh sách các bài viết
            // ListView(
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   children: [
            //     PostCard('Tiêu đề bài viết 1', 'Nội dung bài viết 1'),
            //     PostCard('Tiêu đề bài viết 2', 'Nội dung bài viết 2'),
            //     // Thêm các Card khác nếu có nhiều bài viết
            //   ],
            // ),

            // List các bài viết đã đăng
            buildSectionHeader('Bài viết đã đăng', Icons.library_books),

            // Widget chứa TabBar và TabBarView
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  // TabBar để chọn giữa "Pet Stories" và "Pet Adoption"
                  TabBar(
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
                        buildPostsList(petStoriesPosts),
                        // Nội dung cho tab "Pet Adoption"
                        buildPostsList(petAdoptionPosts),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget hiển thị danh sách bài đăng
  Widget buildPostsList(List<Post> posts) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostCard(posts[index].title, posts[index].content);
      },
    );
  }

  Widget buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24.0, color: Colors.blue),
        SizedBox(width: 8.0),
        Text(
          title,
          style: TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ],
    );
  }

  Widget buildContactInfo(String info, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16.0),
        SizedBox(width: 8.0),
        Text(
          info,
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget buildInfo(String info) {
    return Text(
      info,
      style: TextStyle(fontSize: 16.0),
    );
  }

  // Hàm xử lý khi click vào ảnh avatar để hiển thị ảnh full màn hình
  void _showFullScreenImage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Hero(
            tag: 'avatarTag',
            child:
                Image.asset('assets/images/Lan.jpg'), // Thay đổi đường dẫn ảnh
          ),
        ),
      ),
    ));
  }
}

class PostCard extends StatelessWidget {
  final String title;
  final String content;

  PostCard(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              content,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
