import 'package:hive/hive.dart';

part 'modal_pay_adapter.g.dart'; // Sử dụng build_runner để tạo file này

@HiveType(typeId: 0) // typeId phải là duy nhất
class ModalPay {
  @HiveField(0)
  final String date;
  @HiveField(1)
  final String time;
  @HiveField(2)
  final String nameTo;
  @HiveField(3)
  final String nameFrom;
  @HiveField(4)
  final String bank;
  @HiveField(5)
  final String stkFrom;
  @HiveField(6)
  final String barCode;
  @HiveField(7)
  final String content;
  @HiveField(8)
  final String category;
  @HiveField(9)
  final String tien;
  @HiveField(10)
  final String stkTo;

  ModalPay({
    required this.bank,
    required this.barCode,
    required this.content,
    required this.date,
    required this.nameFrom,
    required this.nameTo,
    required this.stkFrom,
    required this.time,
    required this.category,
    required this.tien,
    required this.stkTo,
  });
}
