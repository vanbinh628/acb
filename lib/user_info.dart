import 'package:hive/hive.dart';

part 'user_info.g.dart';

@HiveType(typeId: 1)
class UserInfo extends HiveObject {
  @HiveField(11)
  String category; // Thể loại

  @HiveField(12)
  String fullName; // Tên đầy đủ

  @HiveField(13)
  String shortName; // Tên viết tắt

  @HiveField(14)
  String accountNumber; // Số tài khoản

  UserInfo({
    required this.category,
    required this.fullName,
    required this.shortName,
    required this.accountNumber,
  });
}
