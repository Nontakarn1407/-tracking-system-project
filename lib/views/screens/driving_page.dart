import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // นำเข้า flutter_map
import 'package:latlong2/latlong.dart';

class DrivingPage extends StatefulWidget {
  const DrivingPage({super.key});

  @override
  _DrivingPageState createState() => _DrivingPageState();
}

class _DrivingPageState extends State<DrivingPage> {
  late MapController mapController;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color.fromARGB(255, 71, 124, 168);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : primaryColor,
        elevation: 0,
        title: Text(
          'รายงานการขับขี่',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
  children: [
    Expanded(
      child: FlutterMap(
       options: MapOptions(
 // จุดเริ่มต้น
  onTap: (tapPosition, point) {
    // ทำการอัปเดตหรือแสดงข้อมูลตามที่ต้องการเมื่อคลิกที่แผนที่
  },
),

        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: [
                  LatLng(13.7563, 100.5018),
                  LatLng(13.7583, 100.5030),
                  LatLng(13.7590, 100.5050),
                ],
                color: Colors.blue,
                strokeWidth: 5,
              ),
            ],
          ),
               
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'รายงานการขับขี่',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '10.27 – 11.02',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white70 : Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'ไม่มีข้อมูลรายงานการขับขี่ในช่วงเวลานี้',
                  style: TextStyle(
                    fontSize: 18,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                _buildMetricRow('ระยะทางรวม', '0 km', isDarkMode),
                _buildMetricRow('เวลารวม', '00:00', isDarkMode),
                _buildMetricRow('การใช้โทรศัพท์', '-', isDarkMode),
                _buildMetricRow('เบรกแรง', '-', isDarkMode),
                _buildMetricRow('เร่งแรง', '-', isDarkMode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
