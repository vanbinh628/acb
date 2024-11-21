import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter1/list.dart';
import 'package:flutter1/main.dart';
import 'package:flutter1/modal_pay_adapter.dart';

class Detail extends StatefulWidget {
  const Detail({super.key, required this.transaction});
  final ModalPay transaction;

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
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

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   showLoadingAndNavigate(context);
    // });
  }

  @override
  Widget build(BuildContext context) {
    String _blockToWords(int block, List<String> units, List<String> tens) {
      int hundreds = block ~/ 100;
      int remainder = block % 100;
      int tensPart = remainder ~/ 10;
      int onesPart = remainder % 10;

      String result = "";

      if (hundreds > 0) {
        result += "${units[hundreds]} trăm";
        if (remainder != 0) {
          result += " ";
        }
      }

      if (tensPart > 0) {
        result += tens[tensPart];
        if (onesPart > 0) {
          if (onesPart == 1 && tensPart > 1) {
            result += " mốt";
          } else if (onesPart == 5) {
            result += " lăm";
          } else {
            result += " ${units[onesPart]}";
          }
        }
      } else if (onesPart > 0) {
        if (hundreds > 0) {
          result += " lẻ ${units[onesPart]}";
        } else {
          result += units[onesPart];
        }
      }

      return result.trim();
    }

    String numberToVietnameseWords(int number) {
      const List<String> units = [
        "",
        "một",
        "hai",
        "ba",
        "bốn",
        "năm",
        "sáu",
        "bảy",
        "tám",
        "chín"
      ];
      const List<String> tens = [
        "",
        "mười",
        "hai mươi",
        "ba mươi",
        "bốn mươi",
        "năm mươi",
        "sáu mươi",
        "bảy mươi",
        "tám mươi",
        "chín mươi"
      ];
      const List<String> levels = ["", "nghìn", "triệu", "tỷ"];

      if (number == 0) return "không đồng";

      String result = "";
      int levelIndex = 0;

      while (number > 0) {
        int block = number % 1000;
        number ~/= 1000;

        if (block > 0) {
          String blockInWords = _blockToWords(block, units, tens);
          result = "$blockInWords ${levels[levelIndex]} $result".trim();
        }
        levelIndex++;
      }

      return "$result đồng".trim();
    }

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/acb.jpg'),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 5.3,
                  left: 20,
                  right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Chuyển tiền thành công!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${widget.transaction.tien} VND',
                    style: TextStyle(
                        color: Color(0xFF0067F8),
                        fontWeight: FontWeight.w800,
                        fontSize: 24),
                  ),
                  Text(
                    numberToVietnameseWords(
                        int.parse(widget.transaction.tien.replaceAll('.', ''))),
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey[100],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 4.3,
                        child: Text(
                          'Từ',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.transaction.nameFrom,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              widget.transaction.stkFrom,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[800],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 4.3,
                        child: Text(
                          'Đến',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.transaction.nameTo,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              widget.transaction.bank,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[800],
                              ),
                            ),
                            Text(
                              widget.transaction.stkTo,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[800],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey[100],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 4.3,
                        child: Text(
                          'Chuyển lúc',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          '${widget.transaction.date}, ${widget.transaction.time}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 4.3,
                        child: Text(
                          'Phí',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          'Miễn phí',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 4.3,
                        child: Text(
                          'Mã giao dịch',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          widget.transaction.barCode,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey[100],
                    ),
                  ),
                  Text(
                    'Nội dung',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    widget.transaction.content,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  height: 50,
                  width: 200,
                  color: Colors.transparent,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
