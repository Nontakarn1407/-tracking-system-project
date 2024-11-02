import 'package:flutter/material.dart';
import 'package:flutter_application_4/views/screens/employee_detail_Sreen.dart';

class EmployeeCard extends StatelessWidget {
  final String name;
  final String location;

  const EmployeeCard({
    required this.name,
    required this.location,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(name, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        subtitle: Text(location, style: const TextStyle(fontSize: 16.0)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EmployeeDetailScreen(),
            ),
          );
        },
      ),
    );
  }
}
