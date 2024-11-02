import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension WidgetToBitmapDescriptor on Widget {
  Future<BitmapDescriptor> toBitmapDescriptor({int width = 120}) async {
    // Create a GlobalKey for the RepaintBoundary
    final GlobalKey repaintKey = GlobalKey();

    // Create a widget with the RepaintBoundary and key
    final Widget boundary = RepaintBoundary(
      key: repaintKey,
      child: Material(
        type: MaterialType.transparency,
        child: this,
      ),
    );

    // Render the widget in an off-screen overlay and capture it
    return await _capturePng(boundary, repaintKey);
  }

  Future<BitmapDescriptor> _capturePng(Widget widget, GlobalKey key) async {
    // Create a completer to wait for the widget to render
    Completer<ui.Image> completer = Completer<ui.Image>();

    // Create an off-screen overlay to hold the widget
    OverlayEntry entry = OverlayEntry(
      builder: (context) => Positioned(
        left: -1000, // Render off-screen
        top: -1000,
        child: Material(
          child: widget,
        ),
      ),
    );

    // Add the overlay to the context
    OverlayState overlayState = Overlay.of(key.currentContext!)!;
    overlayState.insert(entry);

    // Wait for a frame to ensure the widget is rendered
    await Future.delayed(Duration(milliseconds: 50));

    try {
      // Capture the image from the RepaintBoundary
      RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      // Clean up the overlay after rendering
      entry.remove();

      // Convert the image to BitmapDescriptor
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return BitmapDescriptor.defaultMarker;

      Uint8List bytes = byteData.buffer.asUint8List();
      completer.complete(image);

      return BitmapDescriptor.fromBytes(bytes);
    } catch (e) {
      // Handle error and remove the overlay if any issues occur
      entry.remove();
      throw e;
    }
  }
}

Future<BitmapDescriptor> markerIconByImageURL(
    String displayName, String? imageURL) {
  return CircleAvatar(
    // radius: 60,
    backgroundColor: Colors.brown.shade800,
    child: ClipOval(
      child: SizedBox(
        width: 120,
        height: 120,
        child: imageURL == null
            ? Center(
                child: Text(
                  displayName.toUpperCase(),
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              )
            : Image.network(
                imageURL,
                fit: BoxFit.cover,
              ),
      ),
    ),
  ).toBitmapDescriptor();
}
