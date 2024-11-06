import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/user_model.dart';
import 'package:flutter_application_4/views/screens/personal_info_page.dart';
import 'package:image_picker/image_picker.dart';

class EditPersonalInfoPage extends StatefulWidget {
  Map<String, dynamic> userInfo;

  EditPersonalInfoPage(this.userInfo, {super.key});

  @override
  State<EditPersonalInfoPage> createState() => _EditPersonalInfoPageState();
}

class _EditPersonalInfoPageState extends State<EditPersonalInfoPage> {
  UserModel userModel = UserModel();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();

  String _imageUrl = '';

  final Color primaryColor = const Color.fromARGB(255, 71, 124, 168);

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.userInfo['imageUrl'] ?? '';
    _nameController.text = widget.userInfo['name'] ?? '';
    _emailController.text = widget.userInfo['email'] ?? '';
    _phoneController.text = widget.userInfo['phone'] ?? '';
    _employeeIdController.text = widget.userInfo['employeeId'] ?? '';
  }

  void onCLickChangeImageProfile() async {
    final picker = ImagePicker();

    if (kIsWeb) {
      // สำหรับ Web ใช้ readAsBytes เพื่อรับ Uint8List
      final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        Uint8List imageData = await pickedImage.readAsBytes();
        String downloadUrl = await userModel.uploadImageProfileWeb(imageData);
        setState(() {
          _imageUrl = downloadUrl;
        });
      }
    } else {
      // สำหรับมือถือ ใช้ไฟล์โดยตรง
      final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        String downloadUrl = await userModel.uploadImageProfile(pickedImage);
        setState(() {
          _imageUrl = downloadUrl;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Personal Information', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const PersonalInfoPage();
            }));
          },
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 24),
                    Container(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: onCLickChangeImageProfile,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.brown.shade800,
                          child: ClipOval(
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: _imageUrl.isEmpty
                                  ? Center(
                                      child: Text(
                                        widget.userInfo["name"]!.substring(0, 2).toUpperCase(),
                                        style: const TextStyle(fontSize: 34, color: Colors.white),
                                      ),
                                    )
                                  : Image.network(_imageUrl, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextFormField(_employeeIdController, 'Employee ID', true),
                    const SizedBox(height: 16),
                    _buildTextFormField(_emailController, 'Email', true),
                    const SizedBox(height: 16),
                    _buildTextFormField(_nameController, 'Name', false),
                    const SizedBox(height: 16),
                    _buildTextFormField(_phoneController, 'Phone', false),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        onCickSave();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: primaryColor,
                        minimumSize: const Size(double.infinity, 50),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
      TextEditingController controller, String label, bool disable) {
    return TextFormField(
      controller: controller,
      readOnly: disable,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: disable ? Colors.grey[300] : Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }

  void onCickSave() async {
    bool success = await userModel.updateUserInfo(userId: widget.userInfo['employeeId'], data: {
      'displayName': _nameController.text,
      'phoneNumber': _phoneController.text,
    });

    if (success) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const PersonalInfoPage()));
    }
  }
}
