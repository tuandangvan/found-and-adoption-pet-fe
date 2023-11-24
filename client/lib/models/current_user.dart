import 'package:hive/hive.dart';

// part 'hive_solUser.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String accountId;
  @HiveField(2)
  late String email;
  @HiveField(3)
  late String role;
  @HiveField(4)
  late bool isActive;
  @HiveField(5)
  late String firstName;
  @HiveField(6)
  late String lastName;
  @HiveField(7)
  late String phoneNumber;
  @HiveField(8)
  late String avatar;
  @HiveField(9)
  late String address;
  @HiveField(10)
  late String refreshToken;
  @HiveField(11)
  late String accessToken;
}

// HiveAdapter cho User
class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final user = User()
      ..id = reader.readString()
      ..accountId = reader.readString()
      ..email = reader.readString()
      ..role = reader.readString()
      ..isActive = reader.readBool()
      ..firstName = reader.readString()
      ..lastName = reader.readString()
      ..phoneNumber = reader.readString()
      ..avatar = reader.readString()
      ..address = reader.readString()
      ..refreshToken = reader.readString()
      ..accessToken = reader.readString();

    return user;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.accountId);
    writer.writeString(obj.email);
    writer.writeString(obj.role);
    writer.writeBool(obj.isActive);
    writer.writeString(obj.firstName);
    writer.writeString(obj.lastName);
    writer.writeString(obj.phoneNumber);
    writer.writeString(obj.avatar);
    writer.writeString(obj.address);
    writer.writeString(obj.refreshToken);
    writer.writeString(obj.accessToken);
  }
}
