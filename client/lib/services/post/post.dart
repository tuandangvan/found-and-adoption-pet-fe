import 'dart:convert';
import 'package:found_adoption_application/models/post.dart';
import 'package:found_adoption_application/services/api.dart';
import 'package:found_adoption_application/utils/messageNotifi.dart';

Future<List<Post>> getAllPost() async {
  var responseData = {};
  try {
    responseData = await api('/post', 'GET', '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  var postList = responseData['data'] as List<dynamic>;
  List<Post> posts = postList.map((json) => Post.fromJson(json)).toList();
  return posts;
}

Future<String> changeStatusPost(String postId, String status) async {
  var body = jsonEncode(<String, String>{'status': status});
  var responseData = {};
  var message;
  try {
    responseData = await api('/post/$postId/status', 'PUT', body);
    message = responseData['message'];
  } catch (err) {
    print(err);
    //  notification(e.toString(), true);
  }
  return message;
}

Future<List<Post>> getAllPostPersonal(var id) async {
  var responseData;
  try {
    responseData = await api('/post/personal/${id}', 'GET', '');
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
  }
  List<dynamic> postList = List.empty();

  postList = responseData['data'] != null ? responseData['data'] : List.empty();
  List<Post> posts = postList.map((json) => Post.fromJson(json)).toList();
  return posts;
}

Future<bool> addPost(String content, List<dynamic> imagePaths) async {
  var responseData = {};
  var body = jsonEncode({
    "content": content,
    "images": imagePaths,
  });
  try {
    responseData = await api('/post', 'POST', body);
    if (responseData['success']) {
      notification(responseData['message'], false);
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => RegistrationForm()));
      return true;
    } else {
      notification(responseData['message'], true);
      return false;
    }
  } catch (e) {
    print(e);
    //  notification(e.toString(), true);
    return false;
  }
}
