import 'package:flutter/material.dart';

class AddEmployeeScreen extends StatelessWidget {
  const AddEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มพนักงาน'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ชื่อพนักงาน:', style: TextStyle(fontSize: 18)),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'กรุณากรอกชื่อพนักงาน',
              ),
            ),
            const SizedBox(height: 16),
            const Text('ตำแหน่ง:', style: TextStyle(fontSize: 18)),
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'กรุณากรอกตำแหน่ง',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // ฟังก์ชันสำหรับบันทึกข้อมูลพนักงาน
              },
              child: const Text('บันทึก'),
            ),
          ],
        ),
      ),
    );
  }
}
