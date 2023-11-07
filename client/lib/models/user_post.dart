import 'package:hive/hive.dart';

// part 'hive_solUser.g.dart';

@HiveType(typeId: 0)
class UserPost extends HiveObject {
  //id bài viết
  @HiveField(0)
  late String id;
  //id người tạo bài viết
  @HiveField(1)
  late String userId;
  //ngày tạo bài viết
  @HiveField(2)
  late String createdAt;
  //nội dung
  @HiveField(3)
  late String content;
  //tương tác bài viết
  // @HiveField(4)
  // late List<String> reaction;
  //hình ảnh bài viết
  @HiveField(5)
  late List<String> images;
  //Trạng thái bài viết
  // @HiveField(6)
  // late String status;
  // comments
  // @HiveField(7)
  // late List<String> comments;
}

// HiveAdapter cho User
class UserPostAdapter extends TypeAdapter<UserPost> {
  @override
  final int typeId = 1;

  @override
  UserPost read(BinaryReader reader) {
    final userpost = UserPost()
      ..id = reader.readString()
      ..userId = reader.readString()
      ..createdAt = reader.readString()
      ..content = reader.readString()
      // ..reaction = reader.readStringList()
      ..images = reader.readStringList();
    // ..status = reader.readString()
    // ..comments = reader.readStringList();

    return userpost;
  }

  @override
  void write(BinaryWriter writer, UserPost obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.userId);
    writer.writeString(obj.createdAt);
    writer.writeString(obj.content);
    // writer.writeStringList(obj.reaction);
    writer.writeStringList(obj.images);
    // writer.writeString(obj.status);
    // writer.writeStringList(obj.comments);
  }
}
