import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'time.dart';

class TimeEditorScreen extends StatefulWidget {
  const TimeEditorScreen({Key? key}) : super(key: key);

  @override
  _TimeEditorScreenState createState() => _TimeEditorScreenState();
}

class _TimeEditorScreenState extends State<TimeEditorScreen> {
  late Box<Time> timeBox;
  TextEditingController timeStartController = TextEditingController();
  TextEditingController timeEndController = TextEditingController();
  Time? currentTime;

  @override
  void initState() {
    super.initState();
    // Mở box Hive
    timeBox = Hive.box<Time>('time');
    _loadTime();
  }

  void _loadTime() {
    if (timeBox.isNotEmpty) {
      currentTime = timeBox.getAt(0); // Lấy giá trị đầu tiên (nếu có)
      if (currentTime != null) {
        timeStartController.text = currentTime!.timeStart;
        timeEndController.text = currentTime!.timeEnd;
      }
    }
  }
void _saveTime() {
    final newTime = Time(
      timeStart: timeStartController.text,
      timeEnd: timeEndController.text,
    );

    timeBox.put('time_info', newTime); // Lưu với key "time_info"

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Time saved successfully!')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Time'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Start Time:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: timeStartController,
              decoration: const InputDecoration(
                hintText: 'Enter start time',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'End Time:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: timeEndController,
              decoration: const InputDecoration(
                hintText: 'Enter end time',
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _saveTime,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
