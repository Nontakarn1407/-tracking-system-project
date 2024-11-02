import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/user_model.dart';
import 'package:flutter_application_4/views/screens/home_screen.dart';
import 'package:flutter_application_4/views/screens/map_page.dart';
import 'package:flutter_application_4/views/screens/sing_up_screen.dart';
import 'package:flutter_application_4/views/widgets/dialogs/error-dialog.dart';
import 'package:flutter_application_4/views/widgets/dialogs/loading-dialog.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  UserModel userModel = UserModel();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void onPressSignIn() async {
    showDialog(
        context: context,
        builder: (BuildContext context) => const LoadingDialog());

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    UserCredential? user = await userModel.signInWithEmailAndPassword(email, password);

    if (user != null && context.mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      Timer(const Duration(seconds: 2), () {
        Navigator.pop(context, true);
        showDialog(
            context: context,
            builder: (BuildContext context) => const ErrorDialog(
                  title: 'Invalid Email or Password.',
                ));
      });
    }
  }

  void onPressGoToSignUpScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ภาพพื้นหลัง
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgrounds/sign_in_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // เนื้อหา
          Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'ลงชื่อเข้าใช้งาน',
                  style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(height: 40),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  icon: Icons.email,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  icon: Icons.key,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  width: 320,
                  child: FilledButton(
                    onPressed: onPressSignIn,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 71, 124, 168)), // เปลี่ยนสีพื้นหลังของปุ่ม
                    ),
                    child: const Text("Let's Go", style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(height: 30),
                _buildSignUpRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hintText, required IconData icon, bool obscureText = false}) {
    return SizedBox(
      width: 320,
      height: 50,
      child: TextField(
        style: const TextStyle(color: Colors.white),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey[500]),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300),
          fillColor: const Color.fromARGB(255, 71, 124, 168), // เปลี่ยนเป็นสีหลักที่ต้องการ
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'ยังไม่มีบัญชีใช่หรือไม่?',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(width: 10.0),
        GestureDetector(
          onTap: onPressGoToSignUpScreen,
          child: Text(
            'ลงทะเบียน',
            style: TextStyle(color: Colors.yellow[800], fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
