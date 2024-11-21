import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter1/home.dart';
import 'package:flutter1/modal_pay_adapter.dart';
import 'package:flutter1/time.dart';
import 'package:flutter1/user_info.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ModalPayAdapter());
  Hive.registerAdapter(UserInfoAdapter());
  Hive.registerAdapter(TimeAdapter());
  await Hive.openBox<Time>('time');
  await Hive.openBox<ModalPay>('transactions');
  await Hive.openBox<UserInfo>('userInfo');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: HomeScreen(),
        ),
      ),
    );
  }
}

class RotatingAndScalingEffect extends StatefulWidget {
  const RotatingAndScalingEffect({super.key});

  @override
  _RotatingAndScalingEffectState createState() =>
      _RotatingAndScalingEffectState();
}

class _RotatingAndScalingEffectState extends State<RotatingAndScalingEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(); // Lặp lại liên tục
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double progress = _controller.value; // Từ 0 -> 1
          double scaleFactor = sin(progress * pi); // Tạo hiệu ứng gom/tỏa
          return Transform.rotate(
            angle: progress * 2 * pi, // Xoay tròn
            child: Stack(
              children: [
                for (int i = 0; i < 4; i++)
                  Align(
                    alignment: _getAlignment(i, scaleFactor),
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _getColor(i),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Tính toán vị trí của các cục theo scaleFactor
  Alignment _getAlignment(int index, double scaleFactor) {
    // 0: Tâm, 1: Điểm tỏa ra
    switch (index) {
      case 0: // Góc trên
        return Alignment(0, -1 * scaleFactor);
      case 1: // Góc phải
        return Alignment(1 * scaleFactor, 0);
      case 2: // Góc dưới
        return Alignment(0, 1 * scaleFactor);
      case 3: // Góc trái
        return Alignment(-1 * scaleFactor, 0);
      default:
        return Alignment.center;
    }
  }

  /// Trả về màu sắc
  Color _getColor(int index) {
    switch (index) {
      case 0:
        return Colors.lightBlue; // Xanh nhạt
      case 1:
        return Colors.green; // Lá cây
      case 2:
        return Colors.blue[900]!; // Xanh đậm
      case 3:
        return Colors.white; // Trắng
      default:
        return Colors.black;
    }
  }
}
