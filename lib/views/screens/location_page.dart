import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[400], // ใช้สีหลักของแอป
        elevation: 0, // ลบเงาของ AppBar
        title: const Text(
          'Location',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // ปิดหน้า LocationPage
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(13.7563, 100.5018), // ตัวอย่างพิกัด
                zoom: 14.0,
              ),
              markers: {
                const Marker(
                  markerId: MarkerId('locationMarker'),
                  position: LatLng(13.7563, 100.5018), // ตัวอย่างพิกัด
                  infoWindow: InfoWindow(title: 'Your Location'),
                ),
              },
              onMapCreated: (GoogleMapController controller) {
                // คุณสามารถเพิ่มฟังก์ชันอื่น ๆ ที่นี่ถ้าต้องการ
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200], // สีพื้นหลังของ Container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Location:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Latitude: 13.7563\nLongitude: 100.5018',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // ฟังก์ชันสำหรับปุ่ม
                  },
                  child: const Text('Get Current Location'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
