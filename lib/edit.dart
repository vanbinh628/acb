import 'package:flutter/material.dart';
import 'package:flutter1/modal_pay_adapter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late Box<ModalPay> transactionBox;

  @override
  void initState() {
    super.initState();
    if (Hive.isBoxOpen('transactions')) {
      transactionBox = Hive.box<ModalPay>('transactions');
    } else {
      Hive.openBox<ModalPay>('transactions').then((box) {
        setState(() {
          transactionBox = box;
        });
      });
    }
  }

  // Hàm để xóa giao dịch
  void deleteTransaction(int index) {
    setState(() {
      transactionBox.deleteAt(index);
    });
  }

  // Hàm để thêm giao dịch mới
  void addTransaction(ModalPay transaction) {
    setState(() {
      transactionBox.add(transaction);
    });
  }

  void editTransaction(int index, ModalPay updatedTransaction) {
    setState(() {
      transactionBox.putAt(index, updatedTransaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý giao dịch'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // Hiển thị màn hình thêm giao dịch
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddTransactionScreen(
                    onAdd: addTransaction,
                  ),
                ),
              );

              // Kiểm tra nếu có giao dịch mới được thêm
              if (result != null) {
                setState(() {});
              }
            },
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: transactionBox.listenable(),
        builder: (context, Box<ModalPay> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('Chưa có giao dịch nào.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final transaction = box.getAt(index)!;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: transaction.category == '1'
                      ? const Icon(Icons.arrow_downward, color: Colors.grey)
                      : const Icon(Icons.arrow_upward, color: Colors.green),
                  title: Text('${transaction.nameTo} - ${transaction.tien}'),
                  subtitle: Text(
                    'Ngày: ${transaction.date}, Thời gian: ${transaction.time}\n'
                    'Người gửi: ${transaction.nameFrom}, STK: ${transaction.stkFrom}\n'
                    'Ngân hàng: ${transaction.bank}, Mã vạch: ${transaction.barCode}\n'
                    'Nội dung: ${transaction.content}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTransactionScreen(
                                transaction: transaction,
                                index: index,
                                onEdit: editTransaction,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteTransaction(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AddTransactionScreen extends StatefulWidget {
  final Function(ModalPay) onAdd;

  const AddTransactionScreen({super.key, required this.onAdd});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bankController = TextEditingController();
  final _barCodeController = TextEditingController();
  final _contentController = TextEditingController();
  final _dateController = TextEditingController();
  final _nameFromController = TextEditingController();
  final _nameToController = TextEditingController();
  final _stkFromController = TextEditingController();
  final _timeController = TextEditingController();
  final _amountController = TextEditingController();
  final _stlToController = TextEditingController();
  String _selectedCategory = '1';

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final transaction = ModalPay(
        bank: _bankController.text,
        barCode: _barCodeController.text,
        content: _contentController.text,
        date: _dateController.text,
        nameFrom: _nameFromController.text,
        nameTo: _nameToController.text,
        stkFrom: _stkFromController.text,
        time: _timeController.text,
        category: _selectedCategory,
        tien: _amountController.text,
        stkTo: _stlToController.text,
      );

      widget.onAdd(transaction);
      Navigator.pop(context, transaction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm giao dịch')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                textCapitalization: TextCapitalization.characters,
                controller: _nameToController,
                decoration: const InputDecoration(labelText: 'Tên người nhận'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên người nhận';
                  }
                  return null;
                },
              ),
              TextFormField(
                textCapitalization: TextCapitalization.characters,
                controller: _nameFromController,
                decoration: const InputDecoration(labelText: 'Tên người gửi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên người gửi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Số tiền'),
                onChanged: (value) {
                  // Xóa dấu "." trước khi xử lý
                  String newValue = value.replaceAll('.', '');
                  if (newValue.isNotEmpty) {
                    // Định dạng lại giá trị với dấu "."
                    final formatter = NumberFormat(
                        '#,##0', 'vi_VN'); // Sử dụng vi_VN để đảm bảo dấu "."
                    String formattedValue =
                        formatter.format(int.parse(newValue));

                    // Cập nhật lại giá trị vào controller
                    _amountController.value = TextEditingValue(
                      text: formattedValue,
                      selection: TextSelection.collapsed(
                          offset: formattedValue.length),
                    );
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số tiền';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Ngày'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn ngày';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Thời gian'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập thời gian';
                  }

                  // Biểu thức chính quy kiểm tra định dạng HH:mm:ss
                  RegExp timeRegExp =
                      RegExp(r'^([01]?\d|2[0-3]):([0-5]?\d):([0-5]?\d)$');
                  if (!timeRegExp.hasMatch(value)) {
                    return 'Vui lòng nhập đúng định dạng HH:mm:ss';
                  }

                  return null; // Hợp lệ
                },
                keyboardType: TextInputType
                    .datetime, // Hiển thị bàn phím nhập số và ký tự :
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _stkFromController,
                decoration:
                    const InputDecoration(labelText: 'Số tài khoản người gửi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số tài khoản người gửi';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _stlToController,
                decoration:
                    const InputDecoration(labelText: 'Số tài khoản người nhận'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số tài khoản người nhận';
                  }
                  return null;
                },
              ),
              TextFormField(
                textCapitalization: TextCapitalization.characters,
                controller: _bankController,
                decoration: const InputDecoration(
                    labelText: 'Ngân hàng người nhận hoặc gửi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập ngân hàng';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _barCodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Mã giao dịch'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mã giao dịch';
                  }
                  return null;
                },
              ),
              TextFormField(
                textCapitalization: TextCapitalization.characters,
                controller: _contentController,
                decoration:
                    const InputDecoration(labelText: 'Nội dung giao dịch'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập nội dung giao dịch';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Loại giao dịch'),
                items: const [
                  DropdownMenuItem(value: '1', child: Text('Chi tiêu')),
                  DropdownMenuItem(value: '2', child: Text('Thu nhập')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Thêm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditTransactionScreen extends StatefulWidget {
  final ModalPay transaction;
  final int index;
  final Function(int, ModalPay) onEdit;

  const EditTransactionScreen({
    super.key,
    required this.transaction,
    required this.index,
    required this.onEdit,
  });

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _bankController;
  late TextEditingController _barCodeController;
  late TextEditingController _contentController;
  late TextEditingController _dateController;
  late TextEditingController _nameFromController;
  late TextEditingController _nameToController;
  late TextEditingController _stkFromController;
  late TextEditingController _timeController;
  late TextEditingController _amountController;
  late String _selectedCategory;
  late TextEditingController _stkToController;

  @override
  void initState() {
    super.initState();
    final transaction = widget.transaction;
    _bankController = TextEditingController(text: transaction.bank);
    _barCodeController = TextEditingController(text: transaction.barCode);
    _contentController = TextEditingController(text: transaction.content);
    _dateController = TextEditingController(text: transaction.date);
    _nameFromController = TextEditingController(text: transaction.nameFrom);
    _nameToController = TextEditingController(text: transaction.nameTo);
    _stkFromController = TextEditingController(text: transaction.stkFrom);
    _timeController = TextEditingController(text: transaction.time);
    _amountController = TextEditingController(text: transaction.tien);
    _selectedCategory = transaction.category;
    _stkToController = TextEditingController(text: transaction.stkTo);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final updatedTransaction = ModalPay(
        bank: _bankController.text,
        barCode: _barCodeController.text,
        content: _contentController.text,
        date: _dateController.text,
        nameFrom: _nameFromController.text,
        nameTo: _nameToController.text,
        stkFrom: _stkFromController.text,
        time: _timeController.text,
        category: _selectedCategory,
        tien: _amountController.text,
        stkTo: _stkToController.text,
      );

      widget.onEdit(widget.index, updatedTransaction);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa giao dịch')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Các trường nhập liệu (giống AddTransactionScreen)
              TextFormField(
                textCapitalization: TextCapitalization.characters,
                controller: _nameToController,
                decoration: const InputDecoration(labelText: 'Tên người nhận'),
                validator: (value) =>
                    value!.isEmpty ? 'Vui lòng nhập tên người nhận' : null,
              ),
              TextFormField(
                textCapitalization: TextCapitalization.characters,
                controller: _nameFromController,
                decoration: const InputDecoration(labelText: 'Tên người gửi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên người gửi';
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(labelText: 'Ngày'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text =
                          DateFormat('dd/MM/yyyy').format(pickedDate);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng chọn ngày';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(labelText: 'Thời gian'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập thời gian';
                  }

                  // Biểu thức chính quy kiểm tra định dạng HH:mm:ss
                  RegExp timeRegExp =
                      RegExp(r'^([01]?\d|2[0-3]):([0-5]?\d):([0-5]?\d)$');
                  if (!timeRegExp.hasMatch(value)) {
                    return 'Vui lòng nhập đúng định dạng HH:mm:ss';
                  }

                  return null; // Hợp l
                },
                keyboardType: TextInputType
                    .datetime, // Hiển thị bàn phím nhập số và ký tự :
              ),

              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Số tiền'),
                onChanged: (value) {
                  String newValue = value.replaceAll('.', '');
                  if (newValue.isNotEmpty) {
                    final formatter = NumberFormat('#,##0', 'vi_VN');
                    String formattedValue =
                        formatter.format(int.parse(newValue));
                    _amountController.value = TextEditingValue(
                      text: formattedValue,
                      selection: TextSelection.collapsed(
                          offset: formattedValue.length),
                    );
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số tiền';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _stkFromController,
                decoration:
                    const InputDecoration(labelText: 'Số tài khoản người gửi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số tài khoản người gửi';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _stkToController,
                decoration:
                    const InputDecoration(labelText: 'Số tài khoản người nhận'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập số tài khoản người nhận';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bankController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                    labelText: 'Ngân hàng người nhận hoặc gửi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập ngân hàng';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _barCodeController,
                decoration: const InputDecoration(labelText: 'Mã giao dịch'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mã giao dịch';
                  }
                  return null;
                },
              ),
              TextFormField(
                textCapitalization: TextCapitalization.characters,
                controller: _contentController,
                decoration:
                    const InputDecoration(labelText: 'Nội dung giao dịch'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập nội dung giao dịch';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Loại giao dịch'),
                items: const [
                  DropdownMenuItem(value: '1', child: Text('Chi tiêu')),
                  DropdownMenuItem(value: '2', child: Text('Thu nhập')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
