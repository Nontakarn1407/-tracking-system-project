import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/user_model.dart';
import 'package:geolocator/geolocator.dart';

Future<void> updateStatusDialog(
    BuildContext context, Position position, UserModel userModel) {
  TextEditingController _statusController = TextEditingController();
  String selectedStatus = 'รับงาน'; // สถานะเริ่มต้น
  final List<String> taskStatuses = ['รับงาน', 'กำลังดำเนินงาน', 'เสร็จสิ้น']; // รายการสถานะที่เลือก

  void _submit() {
    String statusToUpdate =
        _statusController.text.isNotEmpty ? _statusController.text : selectedStatus;

    // ตรวจสอบว่า userModel ไม่เป็น null
    if (userModel != null) {
      userModel.updateStatus(statusToUpdate, position); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('สถานะถูกอัปเดตเรียบร้อย!'))
      );
      // ไม่ต้องปิด Dialog ที่นี่
    } else {
      // แสดงข้อความแสดงข้อผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการอัปเดตสถานะ!'))
      );
    }
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Update your status 😀'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: _statusController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your status',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Your current location is'),
                  Text(
                    '(${position.latitude}, ${position.longitude})',
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.brown,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text('Select task status:'),
                  DropdownButton<String>(
                    value: selectedStatus,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedStatus = newValue; 
                          _statusController.text = selectedStatus; 
                        });
                      }
                    },
                    items: taskStatuses
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); 
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Submit'),
            onPressed: _submit, 
          ),
        ],
      );
    },
  ).then((_) {
    _statusController.dispose(); // ทำลาย TextEditingController เมื่อต้องการ
  });
}
