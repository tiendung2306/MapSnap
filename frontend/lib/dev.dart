import 'package:flutter/material.dart';

class TimeRangePicker extends StatefulWidget {
  @override
  _TimeRangePickerState createState() => _TimeRangePickerState();
}

class _TimeRangePickerState extends State<TimeRangePicker> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn Mốc Thời Gian'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thời gian bắt đầu:',
              style: TextStyle(fontSize: 16),
            ),
            GestureDetector(
              onTap: () => _selectTime(context, true),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: EdgeInsets.only(top: 8, bottom: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  startTime != null
                      ? startTime!.format(context)
                      : 'Chọn thời gian bắt đầu',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            Text(
              'Thời gian kết thúc:',
              style: TextStyle(fontSize: 16),
            ),
            GestureDetector(
              onTap: () => _selectTime(context, false),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: EdgeInsets.only(top: 8, bottom: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  endTime != null
                      ? endTime!.format(context)
                      : 'Chọn thời gian kết thúc',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (startTime == null || endTime == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Vui lòng chọn đầy đủ thời gian')),
                  );
                  return;
                }
                // Xử lý logic với thời gian
                print('Bắt đầu: ${startTime!.format(context)}');
                print('Kết thúc: ${endTime!.format(context)}');
              },
              child: Text('Xác nhận'),
            ),
          ],
        ),
      ),
    );
  }
}
