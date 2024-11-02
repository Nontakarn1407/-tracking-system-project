import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/main.dart';
import 'package:flutter_application_4/views/screens/home_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class UserModel {
  late final FirebaseAuth auth = FirebaseAuth.instance;
  late final FirebaseFirestore db = FirebaseFirestore.instance;
  late final Reference storage = FirebaseStorage.instance.ref();

  late Map<String, dynamic> userInfo = {
    'email': '',
    'phoneNumber': '',
    'displayName': '',
    'createdAt': DateTime.now(),
  };

  Future<UserCredential?> registerWithEmailPassword(
      String email, String password, String phoneNumber, String displayName) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await db.collection('users').doc(result.user?.uid).set({
        'email': email,
        'phoneNumber': phoneNumber,
        'displayName': displayName,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return result;
    } catch (e) {
      if (kDebugMode) {
        print('Error registering: $e');
      }
      return null;
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      return result;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Error signing in: $e');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error: $e');
      }
      return null;
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    User? user = auth.currentUser;

    if (user != null) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword,
        );

        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
        return true;
      } catch (e) {
        print('Error changing password: $e');
        return false;
      }
    } else {
      print('User is not signed in');
      return false;
    }
  }

  Future<bool> updateUserInfo({required String userId, required Map<String, dynamic> data}) async {
    try {
      await db.collection('users').doc(userId).update(data);
      return true;
    } catch (e) {
      print('Error updating user info: $e');
      return false;
    }
  }

  Future<bool> updateMyLocation({required String userId, required Map<String, dynamic> data}) async {
    try {
      await db.collection('last-location').doc(userId).set(data);
      return true;
    } catch (e) {
      print('Error updating location: $e');
      return false;
    }
  }

  Future<String> uploadImageProfile(XFile file) async {
    try {
      final String fileName = auth.currentUser!.uid;
      final Reference ref = storage.child('profile_images/$fileName.jpg');

      await ref.putFile(File(file.path));
      String url = await ref.getDownloadURL();

      await db.collection('users').doc(auth.currentUser?.uid).update({
        'imageUrl': url,
      });

      return url;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final userDoc = await db.collection('users').doc(auth.currentUser?.uid).get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>?;

        if (data != null) {
          final userData = {
            'email': data['email'],
            'phoneNumber': data['phoneNumber'],
            'displayName': data['displayName'],
            'imageUrl': data.containsKey('imageUrl') ? data['imageUrl'] : null,
            'createdAt': data['createdAt'],
          };

          userInfo = userData;

          return userData;
        } else {
          print('Document has no data!');
          return {};
        }
      } else {
        print('No such document!');
        return {};
      }
    } catch (e) {
      print('Error: $e');
      return {};
    }
  }

  Future checkAuth(BuildContext context) async {
    User? user = auth.currentUser;
    if (user != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  Future<List<Map<String, dynamic>>> getFriendList() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> friends =
          await db.collection('users').get();
      List<Map<String, dynamic>> friendList =
          friends.docs.map((e) => {
            'id': e.id,
            'email': e.data()['email'],
            'displayName': e.data()['displayName'],
            'imageUrl': e.data().containsKey('imageUrl') ? e.data()['imageUrl'] : null,
          }).toList();

      friendList.removeWhere(
          (element) => element['email'] == auth.currentUser?.email);

      return friendList;
    } catch (e) {
      print('Error fetching friends: $e');
      return [];
    }
  }

  Future<String> getImageURL(String userId) async {
    try {
      final userDoc = await db.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>?;

        if (data != null) {
          final userData = {
            'imageUrl': data.containsKey('imageUrl') ? data['imageUrl'] : null,
          };

          return userData['imageUrl'] ?? '';
        }
      }
    } catch (e) {
      print('Error getting image URL: $e');
    }
    return '';
  }

  Future<String> getDisplayName(String userId) async {
    try {
      final userDoc = await db.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>?;

        if (data != null) {
          return data['displayName'] ?? '';
        }
      }
    } catch (e) {
      print('Error getting display name: $e');
    }
    return '';
  }

  Future<List<dynamic>> getOtherEmployeesStatusAndLocation() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> friends =
          await db.collection('last-location').get();

      friends.docs.removeWhere((element) => element.id == auth.currentUser?.uid);

      List friendList = [];
      
      for (var friend in friends.docs) {
        final data = friend.data();
        final friendData = {
          'id': friend.id,
          'latitude': data['latitude'],
          'longitude': data['longitude'],
          'status': data['status'],
          'displayName': await getDisplayName(friend.id),
          'imageUrl': await getImageURL(friend.id),
        };

        friendList.add(friendData);
      }

      return friendList;
    } catch (e) {
      print('Error getting other employees: $e');
      return [];
    }
  }

  void updateStatus(String status, Position position) async {
    final data = {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'status': status,
    };

    await updateMyLocation(userId: auth.currentUser!.uid, data: data);

    await db.collection('location-history').doc().set({
      'userId': auth.currentUser!.uid,
      'latitude': position.latitude,
      'longitude': position.longitude,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List> getLocationHistoryByUserId(String userId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> locationHistory = await db
          .collection('location-history')
          .where('userId', isEqualTo: userId)
          .get();

      List locationHistoryList =
          locationHistory.docs.map((e) => {
            'id': e.id,
            'latitude': e.data()['latitude'],
            'longitude': e.data()['longitude'],
            'status': e.data()['status'],
            'createdAt': e.data()['createdAt'],
          }).toList();

      return locationHistoryList;
    } catch (e) {
      print('Error getting location history: $e');
      return [];
    }
  }

  Future<void> signOut([BuildContext? context]) async {
    await auth.signOut();
    if (context != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MyApp()));
    }
  }
}

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      UserModel userModel = UserModel();

      String oldPassword = _oldPasswordController.text.trim();
      String newPassword = _newPasswordController.text.trim();

      bool success = await userModel.changePassword(oldPassword, newPassword);

      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully!')),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to change password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Old Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your old password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a new password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _changePassword,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
