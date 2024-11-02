import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/theme_notifier.dart';
import 'package:flutter_application_4/models/user_model.dart';
import 'package:flutter_application_4/views/screens/sign_in_screen.dart';
import 'package:flutter_application_4/views/screens/sing_up_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart'; // นำเข้า provider
import 'constants/FirebaseConfig.dart';

import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOption);

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;

  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    initializeMapRenderer();
  }

  await initLocalStorage();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

Completer<AndroidMapRenderer?>? _initializedRendererCompleter;

Future<AndroidMapRenderer?> initializeMapRenderer() async {
  if (_initializedRendererCompleter != null) {
    return _initializedRendererCompleter!.future;
  }

  final Completer<AndroidMapRenderer?> completer =
      Completer<AndroidMapRenderer?>();
  _initializedRendererCompleter = completer;

  WidgetsFlutterBinding.ensureInitialized();

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;

  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    unawaited(mapsImplementation
        .initializeWithRenderer(AndroidMapRenderer.latest)
        .then((AndroidMapRenderer initializedRenderer) =>
            completer.complete(initializedRenderer)));
  } else {
    completer.complete(null);
  }

  return completer.future;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context); // ใช้ Provider

    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeNotifier.themeData, // ใช้ theme จาก ThemeNotifier
      home: const WelcomePage(),
    );
  }
}

// Welcome Page
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final UserModel user = UserModel();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      user.checkAuth(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    void onPressedSignIn() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SignInScreen()));
    }

    void onPressSignUp() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SignUpScreen()));
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/backgrounds/bg.jpg'), // Add your image asset here
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 0, 2, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                      style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                      'แขร์ตำแหน่งแบบเรียลไทม์'),
                  const SizedBox(
                    height: 20,
                  ),
                    SizedBox(
                      height: 50,
                      width: 320,
                      child: FilledButton(
                        onPressed: onPressSignUp,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 71, 124, 168)), // เปลี่ยนสีพื้นหลังของปุ่ม
                        ),
                        child: const Text(
                          "เริ่มต้นใช้งาน",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  Row(
                    children: [
                      const Text(
                        'หากคุณมีบัญชีแล้ว',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      GestureDetector(
                        onTap: onPressedSignIn,
                        child: Text(
                          'ลงชื่อเข้าใช้',
                          style: TextStyle(
                              color: Colors.yellow[800],
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ])
        ],
      ),
    );
  }
}