import 'package:flutter/material.dart';

class EmployeeCard extends StatelessWidget {
  final String name;
  final String location;

  const EmployeeCard({super.key, required this.name, required this.location});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.black,
        ),
        title: Text(name),
        subtitle: Text(location),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EmployeeDetailScreen()),
          );
        },
      ),
    );
  }
}

class EmployeeDetailScreen extends StatelessWidget {
  const EmployeeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Detail'),
      ),
      body: const Center(
        child: Text('Employee Detail Screen'),
      ),
    );
  }
}
