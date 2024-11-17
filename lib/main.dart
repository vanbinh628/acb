import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lịch sử giao dịch',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TransactionHistoryScreen(),
    );
  }
}

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Xử lý nút quay lại
            },
          ),
          title: const Text(
            'Lịch sử giao dịch',
            style: TextStyle(fontSize: 18),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                // Xử lý nút lọc
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              width: 130,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 34, 118, 243)),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '78293847',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 24,
                    )
                  ],
                ),
              ),
            ),
            const TabBar(
              labelColor: Colors.blue, // Màu của tab được chọn
              unselectedLabelColor: Colors.grey, // Màu của tab không được chọn
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                    width: 3.0, color: Colors.blue), // Đường kẻ dưới màu xanh
              ),
              indicatorSize: TabBarIndicatorSize.tab, // Chỉ dài bằng nội dung
              labelStyle: TextStyle(
                fontSize: 16, // Kích thước chữ của tab được chọn
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 16, // Kích thước chữ của tab không được chọn
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
                  TransactionListView(),
                  const Center(child: Text('Chờ xử lý')),
                  const Center(child: Text('Đặt lịch')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionListView extends StatelessWidget {
  final List<Map<String, dynamic>> transactions = [
    {
      'date': '15/11/2024',
      'time': '13:40',
      'name': 'DINH QUOC THAI',
      'description': 'DINH QUOC THAI CHUYEN KHOAN-151124-13:40:30 234545',
      'amount': '-250.000 VND',
    },
    {
      'date': '12/11/2024',
      'time': '21:05',
      'name': 'LUU THI NGAN',
      'description': 'DINH QUOC THAI CHUYEN KHOAN-121124-21:05:24 267111',
      'amount': '-15.000 VND',
    },
    {
      'date': '10/11/2024',
      'time': '21:23',
      'name': 'LUU THI NGAN',
      'description': 'DINH QUOC THAI CHUYEN KHOAN-101124-21:23:44 937323',
      'amount': '-15.000 VND',
    },
    {
      'date': '10/11/2024',
      'time': '21:23',
      'name': 'LUU THI NGAN',
      'description': 'DINH QUOC THAI CHUYEN KHOAN-101124-21:23:44 937323',
      'amount': '-15.000 VND',
    },
    {
      'date': '10/11/2024',
      'time': '21:23',
      'name': 'LUU THI NGAN',
      'description': 'DINH QUOC THAI CHUYEN KHOAN-101124-21:23:44 937323',
      'amount': '-15.000 VND',
    },
    {
      'date': '10/11/2024',
      'time': '21:23',
      'name': 'LUU THI NGAN',
      'description': 'DINH QUOC THAI CHUYEN KHOAN-101124-21:23:44 937323',
      'amount': '-15.000 VND',
    },
    {
      'date': '10/11/2024',
      'time': '21:23',
      'name': 'LUU THI NGAN',
      'description': 'DINH QUOC THAI CHUYEN KHOAN-101124-21:23:44 937323',
      'amount': '-15.000 VND',
    },
    {
      'date': '10/11/2024',
      'time': '21:23',
      'name': 'LUU THI NGAN',
      'description': 'DINH QUOC THAI CHUYEN KHOAN-101124-21:23:44 937323',
      'amount': '-15.000 VND',
    },
    {
      'date': '10/11/2024',
      'time': '21:23',
      'name': 'LUU THI NGAN',
      'description': 'DINH QUOC THAI CHUYEN KHOAN-101124-21:23:44 937323',
      'amount': '-15.000 VND',
    },
  ];

  TransactionListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index == 0 ||
                transactions[index]['date'] != transactions[index - 1]['date'])
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  transaction['date'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              ),
            ListTile(
              leading: const Icon(Icons.arrow_downward, color: Colors.grey),
              title: Text(transaction['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(transaction['description']),
              trailing: Text(transaction['amount'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
