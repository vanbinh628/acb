import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter1/edit.dart';
import 'package:flutter1/list.dart';
import 'package:flutter1/main.dart';
import 'package:flutter1/time.dart';
import 'package:flutter1/timeEditSreen.dart';
import 'package:flutter1/user_info.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void navigateToDetail(
    BuildContext context,
  ) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
             TransactionHistoryScreen(time: time,),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0); // Bắt đầu từ dưới
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  Future<void> showLoading(BuildContext context, Time? time) async {
    print('object : ${time?.timeEnd}');
    final randomDelay = Random().nextInt(int.parse(time?.timeStart ?? '1000')) +
        int.parse(time?.timeEnd ?? '1000');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RotatingAndScalingEffect(),
                  Text(
                    'Đang tải dữ liệu ...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    // Chờ trong thời gian ngẫu nhiên
    await Future.delayed(Duration(milliseconds: randomDelay));

    // Tắt hộp thoại loading
    if (context.mounted) Navigator.of(context).pop();

    // Chuyển đến TransactionHistoryScreen
    if (context.mounted) {
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) =>
               TransactionHistoryScreen(time: time,),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0); // Bắt đầu từ dưới
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            final offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      );
    }
  }

  Future<void> showLoadingAndNavigate(BuildContext context, Time? time) async {
    print('object : ${time?.timeEnd}');
    final randomDelay = Random().nextInt(int.parse(time?.timeStart ?? '1000')) +
        int.parse(time?.timeEnd ?? '1000');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RotatingAndScalingEffect(),
                  Text(
                    'Đang tải dữ liệu ...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );

    // Chờ trong thời gian ngẫu nhiên
    await Future.delayed(Duration(milliseconds: randomDelay));

    // Tắt hộp thoại loading
    if (context.mounted) Navigator.of(context).pop();
  }

  UserInfo? userInfo;
  Time? time;
  Future<void> _loadUserInfo() async {
    UserInfo? info = await getUserInfo();
    Time? timeInfo = await getTime();
    print('object: ${timeInfo?.timeEnd ?? ''}');
    setState(() {
      userInfo = info;
      time = timeInfo;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo();

    // Sử dụng SchedulerBinding để trì hoãn việc gọi hàm
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLoadingAndNavigate(context, time);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/home.jpg'),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Edit(
                      ref: () {
                        _loadUserInfo();
                      },
                    ),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 17,
                    left: MediaQuery.of(context).size.width / 17),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.blue[800]),
                      height: 50,
                      width: 50,
                      child: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          userInfo?.shortName ?? '',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8, top: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userInfo?.category ?? '',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            userInfo?.fullName ?? '',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => showLoading(context, time),
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 15,
                    right: MediaQuery.of(context).size.width / 1.6),
                child: Container(
                  height: 40,
                  width: 40,
                  color: Colors.transparent,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height / 25,
                    ),
                    child: Container(
                      height: 40,
                      width: 40,
                      color: Colors.amber,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 9,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TimeEditorScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height / 25,
                        right: MediaQuery.of(context).size.width / 20),
                    child: Container(
                      height: 40,
                      width: 40,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Edit extends StatefulWidget {
  Edit({super.key, required this.ref});
  final VoidCallback ref;
  @override
  _EditState createState() => _EditState();
}

Future<void> saveUserInfo(UserInfo userInfo) async {
  var box = await Hive.openBox<UserInfo>('userInfoBox');
  await box.put('user_info', userInfo);
}

Future<UserInfo?> getUserInfo() async {
  var box = await Hive.openBox<UserInfo>('userInfoBox');
  return box.get('user_info');
}

Future<Time?> getTime() async {
  var box = await Hive.openBox<Time>('time');
  return box.get('time_info'); // Key khớp với khi lưu
}

class _EditState extends State<Edit> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _shortNameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    UserInfo? info = await getUserInfo();
    if (info != null) {
      _categoryController.text = info.category;
      _fullNameController.text = info.fullName;
      _shortNameController.text = info.shortName;
      _accountNumberController.text = info.accountNumber;
    }
  }

  Future<void> _saveUserInfo() async {
    final userInfo = UserInfo(
      category: _categoryController.text,
      fullName: _fullNameController.text,
      shortName: _shortNameController.text,
      accountNumber: _accountNumberController.text,
    );
    await saveUserInfo(userInfo);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa thông tin')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Thể loại'),
            ),
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(labelText: 'Tên đầy đủ'),
            ),
            TextField(
              controller: _shortNameController,
              decoration: const InputDecoration(labelText: 'Tên viết tắt'),
            ),
            TextField(
              controller: _accountNumberController,
              decoration: const InputDecoration(labelText: 'Số tài khoản'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveUserInfo();
                widget.ref();
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}
