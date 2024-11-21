import 'package:hive/hive.dart';

part 'time.g.dart';

@HiveType(typeId: 2)
class Time extends HiveObject {
  @HiveField(15)
  String timeStart; 

  @HiveField(16)
  String timeEnd; 



  

  Time({
    required this.timeEnd,
    required this.timeStart,
  
  });
  
}