import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/user_model.dart';
import 'package:flutter_application_4/views/screens/menu_page.dart';
import 'package:flutter_application_4/views/screens/sos_screen.dart';
import 'package:flutter_application_4/views/widgets/buttomSheet/friends_list_buttom_sheet.dart';
import 'package:flutter_application_4/views/widgets/dialogs/update_status_dialog.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:latlong2/latlong.dart' as latlong;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  latlong.LatLng? _center; // แก้เป็น latlong.LatLng
  Position? _currentPosition;
  UserModel userModel = UserModel();
  List<Map<String, dynamic>> employees = [];
  Set<google_maps.Marker> markerEmployees = {};

  @override
  void initState() {
    super.initState();
    getUserLocation();
    getFriendList();
    setMarker();
  }

  Future<void> getFriendList() async {
    employees = await userModel.getFriendList();
  }

  Future<void> setMarker() async {
    List employeesLocation =
        await userModel.getOtherEmployeesStatusAndLocation();

    for (var employee in employeesLocation) {
      final File markerImageFile =
          await DefaultCacheManager().getSingleFile(employee['imageUrl']);
      final Uint8List markerImageBytes = await markerImageFile.readAsBytes();

      final ui.Codec codec = await ui.instantiateImageCodec(
        markerImageBytes,
        targetWidth: 120,
        targetHeight: 120,
      );
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image image = frameInfo.image;

      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      final Paint paint = Paint()..isAntiAlias = true;

      final double radius = 60.0;
      paint.color = Colors.transparent;
      canvas.drawCircle(Offset(radius, radius), radius, paint);

      paint.shader = ImageShader(
        image,
        TileMode.clamp,
        TileMode.clamp,
        Matrix4.identity()
            .scaled(120 / image.width, 120 / image.height)
            .storage,
      );
      canvas.drawCircle(Offset(radius, radius), radius, paint);

      final Paint strokePaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10.0
        ..isAntiAlias = true;
      canvas.drawCircle(Offset(radius, radius), radius, strokePaint);

      final ui.Image finalImage =
          await pictureRecorder.endRecording().toImage(120, 120);
      final ByteData? byteData =
          await finalImage.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List resizedMarkerImageBytesWithStroke =
          byteData!.buffer.asUint8List();

      // สร้าง BitmapDescriptor จาก bytes ของ Marker
      final google_maps.BitmapDescriptor markerIcon =
          await google_maps.BitmapDescriptor.fromBytes(
              resizedMarkerImageBytesWithStroke);

      // เพิ่ม Marker ลงใน Set
      markerEmployees.add(
        google_maps.Marker(
          markerId: google_maps.MarkerId(employee['id']),
          position:
              google_maps.LatLng(employee['latitude'], employee['longitude']),
          icon: markerIcon,
        ),
      );
    }

    setState(() {});
  }

  Future<void> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    _currentPosition = await Geolocator.getCurrentPosition();

    await userModel
        .updateMyLocation(userId: userModel.auth.currentUser!.uid, data: {
      'latitude': _currentPosition!.latitude,
      'longitude': _currentPosition!.longitude,
      'lastUpdate': DateTime.now().millisecondsSinceEpoch,
    });

    setState(() {
      _center = latlong.LatLng(_currentPosition!.latitude,
          _currentPosition!.longitude); // แก้เป็น latlong.LatLng
    });
  }

  void moveToMyLocation() {
    if (_center != null) {
      setState(() {
        _center = latlong.LatLng(_currentPosition!.latitude,
            _currentPosition!.longitude); // แก้เป็น latlong.LatLng
      });
    }
  }

  void onClickMenuPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MenuPage()),
    );
  }

  void onClickSosScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SosScreen()),
    );
  }

  void onClickFriendsList() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return friendsListBottomSheet(context, employees);
      },
    );
  }

  void onClickUpdateStatus() {
    if (_currentPosition != null) {
      updateStatusDialog(context, _currentPosition!, userModel);
    }
  }

  ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(15),
      backgroundColor: const Color.fromARGB(255, 71, 124, 168),
      foregroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _center == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  options: MapOptions(),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                  ],
                ),
                Positioned(
                  top: 30,
                  left: 10,
                  child: ElevatedButton(
                    style: buttonStyle(),
                    onPressed: onClickMenuPage,
                    child: const Icon(Icons.settings),
                  ),
                ),
                Positioned(
                  top: 90,
                  left: 10,
                  child: ElevatedButton(
                    style: buttonStyle(),
                    onPressed: onClickSosScreen,
                    child: const Icon(Icons.sos),
                  ),
                ),
                Positioned(
                  top: 150,
                  left: 10,
                  child: ElevatedButton(
                    style: buttonStyle(),
                    onPressed: onClickFriendsList,
                    child: const Icon(Icons.group),
                  ),
                ),
                Positioned(
                  top: 210,
                  left: 10,
                  child: ElevatedButton(
                    style: buttonStyle(),
                    onPressed: onClickUpdateStatus,
                    child: const Icon(Icons.edit),
                  ),
                ),
                Positioned(
                  bottom: 100,
                  right: 10,
                  child: ElevatedButton(
                    style: buttonStyle(),
                    onPressed: moveToMyLocation,
                    child: const Icon(Icons.my_location),
                  ),
                ),
              ],
            ),
    );
  }
}
