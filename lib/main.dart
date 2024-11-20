import 'package:flutter/material.dart';
import 'package:flutter1/detail.dart';
import 'package:flutter1/home.dart';
import 'package:flutter1/modal_pay_adapter.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();

  // Đăng ký adapter trước khi sử dụng
  Hive.registerAdapter(ModalPayAdapter());
  await Hive.openBox<ModalPay>('transactions');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lịch sử giao dịch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
