import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/user_model.dart';
import 'package:flutter_application_4/views/screens/menu_page.dart';
import 'package:flutter_application_4/views/screens/sos_screen.dart';
import 'package:flutter_application_4/views/widgets/buttomSheet/friends_list_buttom_sheet.dart';
import 'package:flutter_application_4/views/widgets/dialogs/update_status_dialog.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_network/image_network.dart';
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
  List employeesMap = [];
  final MapController _mapController = MapController();
  
  get zoomIn => null;
  
  get zoomOut => null;

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

    setState(() {
      employeesMap = employeesLocation;
    });
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
      _mapController.move(_center!, 15.0);
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
      MaterialPageRoute(
          builder: (context) => SosScreen(
                center: _center,
              )),
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
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _center ?? latlong.LatLng(0, 0),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: employeesMap
                          .map<Marker>((e) => Marker(
                              width: 80.0,
                              height: 80.0,
                              point:
                                  latlong.LatLng(e['latitude'], e['longitude']),
                              child: InkWell(
                                onTap: () => showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(e['displayName']),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ImageNetwork(
                                              image: e['imageUrl'],
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              height: 60,
                                              width: 60,
                                              curve: Curves.easeIn,
                                              onLoading: Icon(
                                                Icons.person,
                                                color: Colors.grey,
                                              ),
                                              onError: const Icon(
                                                Icons.error,
                                                color: Colors.red,
                                              ),
                                            ),
                                            Text(e['status'] ?? 'No status'),
                                          ],
                                        ),
                                      );
                                    }),
                                child: IgnorePointer(
                                  child: ImageNetwork(
                                    image: "${e['imageUrl']}",
                                    borderRadius: BorderRadius.circular(50),
                                    height: 60,
                                    width: 60,
                                    curve: Curves.easeIn,
                                    onLoading: Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    ),
                                    onError: const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              )))
                          .toList(),
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
                  top: 676,
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
