import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                      'assets/images/Lan.jpg'), // Thay đổi đường dẫn ảnh
                ),
              ),
            ),
            SizedBox(height: 16.0),

            // Họ và Tên
            Text(
              'Họ và Tên: Nguyễn Văn A',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),

            // Contact me
            buildSectionHeader('Contact me', Icons.mail),
            buildContactInfo('Số điện thoại: 0123 456 789', Icons.phone),
            buildContactInfo('Email: nguyenvana@gmail.com', Icons.email),
            SizedBox(height: 16.0),

            // About me
            buildSectionHeader('About me', Icons.info),
            buildInfo(
                'Mình là một lập trình viên đam mê Flutter và đang xây dựng ứng dụng tuyệt vời!'),
            SizedBox(height: 16.0),

            // Experience
            buildSectionHeader('Experience', Icons.work),
            buildInfo(
                '3 năm kinh nghiệm trong lĩnh vực phát triển ứng dụng di động.'),
            SizedBox(height: 16.0),

            Container(
              width: double.infinity,
              height: 8.0,
              color: const Color.fromARGB(255, 176, 175, 175),
              margin: EdgeInsets.symmetric(vertical: 16.0),
            ),

            // List các bài viết đã đăng
            buildSectionHeader('Bài viết đã đăng', Icons.library_books),
            // Dùng ListView để hiển thị danh sách các bài viết
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                PostCard('Tiêu đề bài viết 1', 'Nội dung bài viết 1'),
                PostCard('Tiêu đề bài viết 2', 'Nội dung bài viết 2'),
                // Thêm các Card khác nếu có nhiều bài viết
              ],
            ),
          ],
        ),
      ),
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
