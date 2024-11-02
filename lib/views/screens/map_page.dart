import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'driving_page.dart';
import 'package:flutter_application_4/views/screens/location_history_screen.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, required List<Map<String, Object>> employeeData, required String employeeId});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color.fromARGB(255, 71, 124, 168);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDarkMode ? Colors.white : primaryColor,
        title: Text(
          'Map',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: isDarkMode ? Colors.black : Colors.white,
              ),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: isDarkMode ? Colors.black : Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              // หากต้องการเพิ่ม Marker ก็สามารถเพิ่มที่นี่
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    '2XFX+C65 ตำบล กำแพงแสน อำเภอ กำแพงแสน นครปฐม',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInfoButton('ประวัติ', onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LocationHistoryScreen(employeeId: 'employeeId'),
                          ),
                        );
                      }),
                      _buildInfoButton('การขับขี่', onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DrivingPage()),
                        );
                      }),
                      _buildInfoButton('แชร์'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoButton(String label, {VoidCallback? onPressed}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color.fromARGB(255, 71, 124, 168);
    
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
      onPressed: onPressed ?? () {
        // ฟังก์ชันสำหรับปุ่มที่ไม่ได้กำหนด
      },
      child: Text(label),
    );
  }
}
