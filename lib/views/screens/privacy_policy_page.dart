import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 20),
              Text(
                'Your privacy is important to us. We take your privacy seriously and will not share your information without your consent.',
                style: TextStyle(fontSize: 16),
              ),
              // คุณสามารถเพิ่มเนื้อหาเพิ่มเติมที่นี่
            ],
          ),
        ),
      ),
    );
  }
}
