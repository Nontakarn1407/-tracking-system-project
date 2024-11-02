import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/user_model.dart';
import 'package:flutter_application_4/views/screens/home_screen.dart';
import 'package:flutter_application_4/views/screens/map_page.dart';
import 'package:flutter_application_4/views/screens/sign_in_screen.dart';
import 'package:flutter_application_4/views/widgets/dialogs/error-dialog.dart';
import 'package:flutter_application_4/views/widgets/dialogs/loading-dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _displayNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  UserModel userModel = UserModel();

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void onPressGoToSignInScreen() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SignInScreen()));
    }

    void onPressSignUp() async {
      String email = _emailController.text;
      String password = _passwordController.text;
      String phoneNumber = _phoneNumberController.text;
      String displayName = _displayNameController.text;

      showDialog(
          context: context,
          builder: (BuildContext context) => const LoadingDialog());

      if (email != '' &&
          password != '' &&
          phoneNumber != '' &&
          displayName != '') {
        UserCredential? user = await userModel.registerWithEmailPassword(
            email, password, phoneNumber, displayName);

        if (user != null && context.mounted) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else {
          Timer(const Duration(seconds: 2), () {
            Navigator.pop(context, true);
            showDialog(
                context: context,
                builder: (BuildContext context) => const ErrorDialog(
                      title: 'Please fill in all information completely.',
                    ));
          });
        }
      }
    }

    const Color primaryColor = Color.fromARGB(255, 71, 124, 168); // สีหลัก

    return Scaffold(
        body: Stack(
      children: [
        // Background Image
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/backgrounds/sign_up_bg.jpg'), // Add your image asset here
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Content
        Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                  'ลงทะเบียน'),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: 320,
                height: 50,
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: _displayNameController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.grey[500],
                      ),
                      hintText: 'Display Name',
                      hintStyle: TextStyle(
                          color: Colors.grey[500], fontWeight: FontWeight.w300),
                      fillColor: primaryColor, // เปลี่ยนสีพื้นหลังเป็นสีหลัก
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white),
                      )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 320,
                height: 50,
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: _emailController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.grey[500],
                      ),
                      hintText: 'Email',
                      hintStyle: TextStyle(
                          color: Colors.grey[500], fontWeight: FontWeight.w300),
                      fillColor: primaryColor, // เปลี่ยนสีพื้นหลังเป็นสีหลัก
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white),
                      )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 320,
                height: 50,
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.key,
                        color: Colors.grey[500],
                      ),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                          color: Colors.grey[500], fontWeight: FontWeight.w300),
                      fillColor: primaryColor, // เปลี่ยนสีพื้นหลังเป็นสีหลัก
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white),
                      )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 320,
                height: 50,
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.grey[500],
                      ),
                      hintText: 'Phone Number',
                      hintStyle: TextStyle(
                          color: Colors.grey[500], fontWeight: FontWeight.w300),
                      fillColor: primaryColor, // เปลี่ยนสีพื้นหลังเป็นสีหลัก
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white),
                      )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                width: 320,
                child: FilledButton(
                  onPressed: onPressSignUp,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(primaryColor), // เปลี่ยนสีปุ่มเป็นสีหลัก
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  const Text(
                    'มีบัญชีอยู่แล้วใช่ไหม?',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  GestureDetector(
                    onTap: onPressGoToSignInScreen,
                    child: Text(
                      'ลงชื่อเข้าใช้งาน',
                      style: TextStyle(
                          color: Colors.yellow[800],
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    ),
                  )
                ],
              )
            ],
          )
        ])
      ],
    ));
  }
}
