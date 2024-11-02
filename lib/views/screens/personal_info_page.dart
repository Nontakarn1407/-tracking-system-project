import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/user_model.dart';
import 'edit_personal_info_page.dart';
import 'menu_page.dart'; // นำเข้าไฟล์หน้าจอเมนูของคุณ

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  UserModel userModel = UserModel();

  late Map<String, dynamic> userInfo = {
    'name': '',
    'email': '',
    'phone': '',
    'employeeId': '',
    'imageUrl': null,
  };

  bool isLoading = true;

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  void getUserInfo() async {
    final data = await userModel.getUserInfo();
    setState(() {
      userInfo['name'] = data['displayName'] ?? '';
      userInfo['email'] = data['email'] ?? '';
      userInfo['phone'] = data['phoneNumber'] ?? '';
      userInfo['employeeId'] = userModel.auth.currentUser?.uid ?? '';
      userInfo['imageUrl'] = data['imageUrl'] ?? '';
      isLoading = false;
    });
  }

  void _navigateToEditPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditPersonalInfoPage(userInfo)),
    );
    if (result != null) {
      setState(() {
        userInfo = result; // สมมติว่าผลลัพธ์คือข้อมูลที่อัปเดต
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Information',
          style: TextStyle(color: isDarkMode ? Colors.black : Colors.white),
        ),
        iconTheme: IconThemeData(color: isDarkMode ? Colors.black : Colors.white),
        backgroundColor: isDarkMode ? Colors.white : const Color.fromARGB(255, 71, 124, 168),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.black : Colors.white),
          onPressed: () {
            // นำทางไปยังหน้าเมนูที่คุณต้องการที่นี่
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuPage()), // แทนที่ MenuPage ด้วยชื่อหน้าจริง
            );
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(16.0),
              color: isDarkMode ? Colors.black : Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 24),
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.brown.shade800,
                      child: ClipOval(
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: userInfo['imageUrl'] == null || userInfo['imageUrl'] == ''
                              ? Center(
                                  child: Text(
                                    (userInfo["name"]?.isNotEmpty == true ? userInfo["name"][0] : 'A').toUpperCase(),
                                    style: const TextStyle(fontSize: 34, color: Colors.white),
                                  ),
                                )
                              : Image.network(
                                  userInfo['imageUrl'],
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInfoTile(Icons.person, 'Name: ${userInfo["name"]}'),
                  _buildInfoTile(Icons.email, 'Email: ${userInfo["email"]}'),
                  _buildInfoTile(Icons.phone, 'Phone: ${userInfo["phone"]}'),
                  _buildInfoTile(Icons.badge, 'Employee ID: ${userInfo["employeeId"]}'),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: _navigateToEditPage,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: isDarkMode ? Colors.black : Colors.white,
                        backgroundColor: isDarkMode ? Colors.white : const Color.fromARGB(255, 71, 124, 168),
                        side: BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text('Edit Information'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoTile(IconData icon, String text) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color.fromARGB(255, 71, 71, 71) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Icon(
          icon,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        title: Text(
          text,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.grey[800]),
        ),
      ),
    );
  }
}
