import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/user_model.dart';
import 'package:flutter_application_4/views/screens/home_screen.dart';
import 'personal_info_page.dart'; // นำเข้าหน้าข้อมูลผู้ใช้
import 'change_password_page.dart' as change_password; // ใช้ prefix
import 'package:flutter_application_4/views/screens/settings_page.dart'; // นำเข้าหน้าการตั้งค่า
import 'package:flutter_application_4/views/screens/event_calendar_page.dart';
 // นำเข้าหน้า Event Calendar

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  UserModel userModel = UserModel();
  late Map<String, dynamic> userInfo = {
    'name': '',
    'email': '',
    'phone': '',
    'employeeId': '',
    'imageUrl': '',
  };
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  // ฟังก์ชันดึงข้อมูลผู้ใช้
  Future<void> _fetchUserInfo() async {
    try {
      final value = await userModel.getUserInfo();
      setState(() {
        userInfo['name'] = value['displayName'] ?? 'Unnamed User';
        userInfo['email'] = value['email'] ?? 'No email';
        userInfo['phone'] = value['phoneNumber'] ?? 'No phone number';
        userInfo['employeeId'] = userModel.auth.currentUser?.uid ?? '';
        userInfo['imageUrl'] = value['imageUrl'] ?? '';
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user info: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: isLoading 
        ? _buildLoadingIndicator(context)
        : _buildMenuContent(context),
    );
  }

  // ฟังก์ชันสร้าง AppBar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Menu',
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
            return const HomeScreen();
          }));
        },
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark 
          ? Colors.white
          : Color.fromARGB(255, 71, 124, 168),
    );
  }

  // ฟังก์ชันแสดง Loading Indicator
  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  // ฟังก์ชันสร้างเนื้อหาของหน้าเมนู
  Widget _buildMenuContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          _buildUserProfileCard(context),
          _buildMenuOption(
            icon: Icons.lock,
            text: 'Change Password',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const change_password.ChangePasswordPage()),
            ),
          ),
          _buildMenuOption(
            icon: Icons.calendar_today, // ใช้ไอคอนปฏิทิน
            text: 'Event Calendar',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EventCalendarPage()), // นำไปยัง Event Calendar
            ),
          ),
          _buildMenuOption(
            icon: Icons.settings,
            text: 'Settings',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            ),
          ),
          const Spacer(),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  // ฟังก์ชันสร้างการ์ดโปรไฟล์ผู้ใช้
  Widget _buildUserProfileCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PersonalInfoPage()),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: userInfo['imageUrl'] != ''
                    ? NetworkImage(userInfo['imageUrl'])
                    : const AssetImage('assets/default_profile.png') as ImageProvider,
                backgroundColor: Colors.grey[300],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userInfo['name'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userInfo['email'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันสร้างปุ่มเมนู
  Widget _buildMenuOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).iconTheme.color),
      title: Text(
        text,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black),
      ),
      onTap: onTap,
    );
  }

  // ฟังก์ชันสร้างปุ่มออกจากระบบ
  Widget _buildLogoutButton() {
    return ListTile(
      leading: const Icon(
        Icons.exit_to_app,
        color: Colors.red,
      ),
      title: const Text(
        'Logout',
        style: TextStyle(color: Colors.red),
      ),
      onTap: () {
        _showLogoutDialog();
      },
    );
  }

  // ฟังก์ชันแสดง dialog ยืนยันการออกจากระบบ
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                userModel.signOut(context); // เรียกฟังก์ชัน signOut
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
