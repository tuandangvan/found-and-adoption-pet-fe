import 'package:hive/hive.dart';

// part 'hive_solUser.g.dart';

@HiveType(typeId: 1)
class CurrentCenter extends HiveObject {
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
  late String name;

  @HiveField(6)
  late String avatar;

  @HiveField(7)
  late String phoneNumber;
  @HiveField(8)
  late String address;
  @HiveField(9)
  late String refreshToken;
  @HiveField(10)
  late String accessToken;
}

// HiveAdapter cho User
class CenterAdapter extends TypeAdapter<CurrentCenter> {
  @override
  final int typeId = 1;

  @override
  CurrentCenter read(BinaryReader reader) {
    final currentCenter = CurrentCenter()
      ..id = reader.readString()
      ..accountId = reader.readString()
      ..email = reader.readString()
      ..role = reader.readString()
      ..isActive = reader.readBool()
      ..name = reader.readString()
      ..avatar = reader.readString()
      ..phoneNumber = reader.readString()
      ..address = reader.readString()
      ..refreshToken = reader.readString()
      ..accessToken = reader.readString();

    return currentCenter;
  }

  @override
  void write(BinaryWriter writer, CurrentCenter obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.accountId);
    writer.writeString(obj.email);
    writer.writeString(obj.role);
    writer.writeBool(obj.isActive);
    writer.writeString(obj.name);
    writer.writeString(obj.avatar);
    writer.writeString(obj.phoneNumber);
    writer.writeString(obj.address);
    writer.writeString(obj.refreshToken);
    writer.writeString(obj.accessToken);
  }
}
