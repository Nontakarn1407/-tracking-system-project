import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // นำเข้าแพ็คเกจ OpenStreetMap
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // นำเข้า Firestore
import 'package:latlong2/latlong.dart'; // สำหรับ LatLng

class SosScreen extends StatefulWidget {
  @override
  _SosScreenState createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  LatLng _currentPosition = LatLng(13.7563, 100.5018); // ตำแหน่งตัวอย่าง (Bangkok)
  TextEditingController _messageController = TextEditingController(); // ตัวควบคุมข้อความ

  // ตัวอย่างรายชื่อผู้ติดต่อฉุกเฉิน
  final List<Map<String, String>> _emergencyContacts = [
    {'name': 'John Doe', 'phone': '123-456-7890'},
    {'name': 'Jane Smith', 'phone': '098-765-4321'},
    {'name': 'Alice Johnson', 'phone': '555-555-5555'},
  ];

  // ฟังก์ชันสำหรับส่ง SOS
  void _sendSOS() async {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('sos_messages').add({
          'latitude': _currentPosition.latitude,
          'longitude': _currentPosition.longitude,
          'message': message,
          'timestamp': Timestamp.now(),
        });

        print("SOS sent! Message: $message");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('SOS message sent!')),
        );
        _messageController.clear(); // เคลียร์ข้อความหลังส่ง
      } catch (e) {
        print("Error sending SOS: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send SOS')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a message before sending')),
      );
    }
  }

  void _callContact(String phoneNumber) async {
    if (await canLaunch("tel:$phoneNumber")) {
      await launch("tel:$phoneNumber");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Calling $phoneNumber')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $phoneNumber')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    var tileLayer = TileLayer(
      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      subdomains: ['a', 'b', 'c'],
    );

    var flutterMap = FlutterMap(
                  options: MapOptions(
                    onTap: (tapPosition, point) {
                      setState(() {
                        _currentPosition = point; // อัปเดตตำแหน่งปัจจุบัน
                      });
                    },
                    crs: const Epsg3857(),
                  ),
                  children: [ // เพิ่ม children ตรงนี้
      tileLayer, // ตัวอย่าง TileLayer
                  ],
                );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SOS',
          style: TextStyle(color: isDarkMode ? Colors.black : Colors.white),
        ),
        iconTheme: IconThemeData(color: isDarkMode ? Colors.black : Colors.white),
        backgroundColor: isDarkMode ? Colors.white : const Color.fromARGB(255, 71, 124, 168),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // แผนที่ OSM
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: flutterMap,
              ),
            ),
            // ช่องให้พิมพ์ข้อความ
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your message',
                labelStyle: TextStyle(color: isDarkMode ? Colors.grey : Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: isDarkMode ? Colors.blue : const Color.fromARGB(255, 71, 124, 168)),
                ),
              ),
              maxLines: 2,
            ),
            SizedBox(height: 20),

            // ปุ่มส่ง SOS
            ElevatedButton(
              onPressed: _sendSOS,
              child: Text(
                'Send SOS',
                style: TextStyle(color: isDarkMode ? Colors.black : Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDarkMode ? Colors.white : const Color.fromARGB(255, 71, 124, 168),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),

            // รายชื่อผู้ติดต่อฉุกเฉิน
            Text(
              'Emergency Contacts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _emergencyContacts.length,
                itemBuilder: (context, index) {
                  var contact = _emergencyContacts[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    color: isDarkMode ? Colors.grey[850] : Colors.white,
                    child: ListTile(
                      title: Text(
                        contact['name'] ?? 'Unknown',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        'Phone: ${contact['phone'] ?? 'N/A'}',
                        style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.call),
                        color: isDarkMode ? Colors.white : const Color.fromARGB(255, 71, 124, 168),
                        onPressed: () {
                          _callContact(contact['phone']!);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// เพิ่มคลาส SOSModel สำหรับการจัดการข้อมูล SOS
class SOSModel {
  String id;
  String userId;
  GeoPoint location; // ใช้ GeoPoint สำหรับ Firebase
  DateTime timestamp;

  SOSModel({
    required this.id,
    required this.userId,
    required this.location,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'location': location,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
