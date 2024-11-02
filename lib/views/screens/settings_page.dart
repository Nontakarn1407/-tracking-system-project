import 'package:flutter/material.dart';
import 'package:flutter_application_4/views/screens/menu_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_4/models/theme_notifier.dart';
import 'privacy_policy_page.dart'; // นำเข้า PrivacyPolicyPage
import 'help_and_faq_page.dart'; // นำเข้า HelpAndFAQPage

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const MenuPage();
            }));
          },
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark 
            ? Colors.white 
            : Color.fromARGB(255, 71, 124, 168),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // ปุ่ม Privacy Policy
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyPage(),
                  ),
                );
              },
            ),

            // ปุ่ม Help & FAQ
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & FAQ'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpAndFAQPage(),
                  ),
                );
              },
            ),

            // ปุ่มเกี่ยวกับ
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('About'),
                      content: const Text(
                        'This app is designed to help users share their real-time location with others easily and securely.\n\n'
                        'Features:\n'
                        '- Real-time location sharing\n'
                        '- User authentication\n'
                        '- Easy to use interface\n'
                        '- Secure data storage\n\n'
                        'Developer: Nonthakarn Nakpaen',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // ปิด Dialog
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            // ปุ่มเปลี่ยนธีม
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('Change Theme Color'),
              onTap: () {
                themeNotifier.toggleTheme(); // สลับธีมเมื่อถูกกด
              },
            ),

            const Divider(), // เส้นแบ่งระหว่างตัวเลือก
          ],
        ),
      ),
    );
  }
}
