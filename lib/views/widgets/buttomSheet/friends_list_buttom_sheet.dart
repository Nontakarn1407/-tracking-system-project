import 'package:flutter/material.dart';
import 'package:flutter_application_4/views/screens/location_history_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

Widget friendsListBottomSheet(
    BuildContext context, List<Map<String, dynamic>> employees) {
  
  // ดึง userId ของพนักงานที่กำลังเข้าสู่ระบบ
  String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  void onClickEmployee(String employeeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationHistoryScreen(
          employeeId: employeeId,
        ),
      ),
    );
  }

  return BottomSheet(
    onClosing: () {},
    builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            const SizedBox(
              height: 60,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 2, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Employee List',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // แสดงรายชื่อพนักงาน
            Expanded(
              child: employees.isNotEmpty
                  ? ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        final employee = employees[index];
                        bool isCurrentUser = employee['id'] == currentUserId;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.brown.shade800,
                            child: ClipOval(
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: employee['imageUrl'] == null ||
                                        employee['imageUrl'].isEmpty
                                    ? Center(
                                        child: Text(
                                          employee["displayName"] != null
                                              ? employee["displayName"]![0]
                                                  .toUpperCase()
                                              : 'N/A',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      )
                                    : Image.network(
                                        employee['imageUrl'],
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                          title: Text(employee['displayName'] ?? 'Unknown'),
                          subtitle: Row(
                            children: [
                              const Icon(
                                Icons.email,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                employee['email'] ?? 'No email',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          onTap: () {
                            onClickEmployee(employee['id']);
                          },
                          // เพิ่มข้อความบ่งบอกว่ากำลังเข้าสู่ระบบอยู่
                          trailing: isCurrentUser 
                              ? const Text(
                                  ' (You)',
                                  style: TextStyle(color: Colors.green),
                                ) 
                              : null,
                        );
                      },
                    )
                  : const Center(
                      child: Text('No employees available'),
                    ),
            ),
          ],
        ),
      );
    },
  );
}

// ฟังก์ชันสำหรับแสดง BottomSheet
void showEmployeesBottomSheet(BuildContext context, List<Map<String, dynamic>> employees) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return friendsListBottomSheet(context, employees);
    },
  );
}
