import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter1/home.dart';
import 'package:flutter1/main.dart';
import 'package:flutter1/modal_pay_adapter.dart';
import 'package:flutter1/time.dart';
import 'package:flutter1/user_info.dart';
import 'package:hive/hive.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter1/detail.dart';

class TransactionHistoryScreen extends StatefulWidget {
  TransactionHistoryScreen({super.key, required this.time});
  Time? time;
  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  UserInfo? userInfo;
  Future<void> _loadUserInfo() async {
    UserInfo? info = await getUserInfo();
    setState(() {
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   showLoadingAndNavigate(context);
      // });
      userInfo = info;
    });
  }

  Future<void> showLoadingAndNavigate(BuildContext context) async {
    // Thời gian delay ngẫu nhiên từ 1 đến 2 giây
    final randomDelay = Random().nextInt(1000) + 1000; // Từ 1000ms -> 2000ms

    // Hiển thị loading
    showDialog(
      context: context,
      barrierDismissible:
          false, // Không cho phép tắt loading bằng cách nhấn ra ngoài
      builder: (context) {
        return Stack(
          children: [
            // Nền che mờ
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            // Hiệu ứng loading
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RotatingAndScalingEffect(),
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

  @override
  void initState() {
    super.initState();

    _loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Lịch sử giao dịch',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          Image.asset(
            'assets/images/filter.png',
            height: 25,
            width: 25,
            color: const Color(0xFF2669EC),
          )
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFF0067F8)),
              child: Padding(
                padding: EdgeInsets.all(6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      userInfo?.accountNumber ?? '',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 26,
                    )
                  ],
                ),
              ),
            ),
            const TabBar(
              dividerColor: Colors.transparent,
              labelColor: Color(0xFF0067F8),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.transparent,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 3.0, color: Color(0xFF0067F8)),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
              tabs: [
                Tab(text: 'Đã thực hiện'),
                Tab(text: 'Chờ xử lý'),
                Tab(text: 'Đặt lịch'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  TransactionListView(
                    time: widget.time,
                  ),
                  Center(child: Text('Chờ xử lý')),
                  Center(child: Text('Đặt lịch')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionListView extends StatefulWidget {
  TransactionListView({super.key, required this.time});
  Time? time;
  @override
  _TransactionListViewState createState() => _TransactionListViewState();
}

class _TransactionListViewState extends State<TransactionListView> {
  late Future<Box<ModalPay>> transactionBoxFuture;

  @override
  void initState() {
    super.initState();
    // Gán giá trị Future cho việc mở Hive Box
    transactionBoxFuture = _openTransactionBox();
  }

  // Mở box giao dịch
  Future<Box<ModalPay>> _openTransactionBox() async {
    return await Hive.openBox<ModalPay>('transactions');
  }

  // Nhóm giao dịch theo ngày
  Map<String, List<ModalPay>> groupTransactionsByDate(
      List<ModalPay> transactions) {
    final Map<String, List<ModalPay>> groupedTransactions = {};
    for (var transaction in transactions) {
      if (!groupedTransactions.containsKey(transaction.date)) {
        groupedTransactions[transaction.date] = [];
      }
      groupedTransactions[transaction.date]!.add(transaction);
    }
    return groupedTransactions;
  }

  void navigateToDetail(BuildContext context, ModalPay transaction) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            Detail(transaction: transaction),
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box<ModalPay>>(
      future: transactionBoxFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Không có dữ liệu giao dịch'));
        }

        final transactionBox = snapshot.data!;
        final groupedTransactions =
            groupTransactionsByDate(transactionBox.values.toList());
        final dates = groupedTransactions.keys.toList();
        Future<void> showLoadingAnd(
            BuildContext context, Time? time, ModalPay transaction) async {
          print('object : ${time?.timeEnd}');
          final randomDelay =
              Random().nextInt(int.parse(time?.timeStart ?? '1000')) +
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
                    Detail(transaction: transaction),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0); // Bắt đầu từ dưới
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  final tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
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

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Text(
                '30 ngày gần nhất',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: dates.map((date) {
                  final items = groupedTransactions[date]!;
                  return SliverStickyHeader(
                    header: Container(
                      height: 40,
                      color: Colors.grey[50],
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        date,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600]),
                      ),
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final transaction = items[index];
                          return GestureDetector(
                            onTap: () => transaction.category == '1'
                                ? showLoadingAnd(
                                    context, widget.time, transaction)
                                : () {},
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: const Color(0xFFF5F3FA)),
                                            child: transaction.category == '1'
                                                ? const Icon(
                                                    Icons.arrow_downward,
                                                    size: 16,
                                                    color: Colors.grey)
                                                : const Icon(Icons.arrow_upward,
                                                    size: 16,
                                                    color: Colors.green),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 4),
                                            child: Text(
                                              transaction.time.substring(0, 5),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[800]),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '${transaction.category == '1' ? '-' : '+'} ${transaction.tien}',
                                        style: TextStyle(
                                            color: transaction.category == '1'
                                                ? Colors.black
                                                : Colors.green,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Text(
                                      transaction.nameTo,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          transaction.content,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[800]),
                                        ),
                                      ),
                                      if (transaction.category == '1')
                                        Icon(
                                          Icons.more_horiz,
                                          color: Colors.grey,
                                        )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 4),
                                    child: Container(
                                      width: double.infinity,
                                      height: 1,
                                      color: Colors.grey[200],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: items.length,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
