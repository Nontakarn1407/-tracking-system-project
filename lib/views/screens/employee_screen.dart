import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/employee_card.dart';
// ignore: duplicate_import
import 'package:flutter_application_4/models/employee_card.dart'; // ใช้เส้นทางที่ถูกต้อง
import 'add_employee_screen.dart';  // เพิ่มการนำเข้า

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('พนักงานทั้งหมด'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEmployeeScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const EmployeeCard(
            name: 'นนทกาญจน์ นาคแป้น',
            location: 'ตำบล กำแพงแสน Now',
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddEmployeeScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[100],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8),
                  Text('เพิ่มพนักงาน'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
