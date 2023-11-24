/*Các bước triển khai websocket
1. import thư viện:      import 'package:web_socket_channel/io.dart';
2. Trong hàm khởi tạo initState ()

   @override
  void initState() {
    super.initState();

    // Kết nối đến server thông qua WebSocket
    channel = IOWebSocketChannel.connect('ws://your_socket_server_url');

    // Lắng nghe sự kiện khi có tin nhắn mới từ server
    channel.stream.listen((message) {
      // Xử lý tin nhắn từ server
      print('Received message from server: $message');
      // Update UI với dữ liệu mới nếu cần
      updateUIWithNewComment(Comment.fromJson(json.decode(message)));
    });
  }

3. Nhớ đóng kết nối
   @override
  void dispose() {
    // Đóng kết nối khi widget bị hủy
    channel.sink.close();
    super.dispose();
  }

4. Cập nhật UI với dữ liệu mới 
  void updateUIWithNewComment(Comment newComment) {
    setState(() {
      comments.insert(0, newComment);
    });
  }

5. Gửi comment đến server thông qua websocket

  void sendCommentToServer(String comment) {
    // Tạo một đối tượng Comment mới từ dữ liệu comment và postId
    Comment newComment = Comment(userId: 1, content: comment, postId: widget.postId);

    // Chuyển đối tượng Comment thành chuỗi JSON để gửi đi
    String jsonComment = json.encode(newComment);

    // Gửi thông điệp tới server
    channel.sink.add(jsonComment);
  }



*/