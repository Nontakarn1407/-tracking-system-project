import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  void _changePassword() {
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New password and confirmation do not match')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate password change process
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );
      Navigator.pop(context);
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: TextStyle(
            color: isDarkMode ? Colors.black : Colors.white, // เปลี่ยนสีข้อความตามโหมด
          ),
        ),
        backgroundColor: isDarkMode ? Colors.white : const Color.fromARGB(255, 71, 124, 168), // เปลี่ยนพื้นหลังตามโหมด
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.black : Colors.white, // เปลี่ยนสีปุ่มกดกลับตามโหมด
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // Old Password Field
            _buildPasswordField('Old Password', _oldPasswordController, isDarkMode),
            const SizedBox(height: 16),

            // New Password Field
            _buildPasswordField('New Password', _newPasswordController, isDarkMode),
            const SizedBox(height: 16),

            // Confirm Password Field
            _buildPasswordField('Confirm Password', _confirmPasswordController, isDarkMode),
            const SizedBox(height: 20),

            // Change Password Button
           ElevatedButton(
              onPressed: _isLoading ? null : _changePassword,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.black) // สีของวงกลมโหลด
                  : Text(
                      'Change Password',
                      style: TextStyle(
                        color: isDarkMode ? Colors.black : Colors.white, // สีข้อความตามโหมด
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode
                    ? Colors.white // สีพื้นหลังปุ่มในโหมดมืด
                    : const Color.fromARGB(255, 71, 124, 168), // สีพื้นหลังปุ่มในโหมดปกติ
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool isDarkMode) {
    return Card(
      elevation: 4,
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
            border: const OutlineInputBorder(),
          ),
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
