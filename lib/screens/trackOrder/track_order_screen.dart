import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class OrderTrackingPage extends StatefulWidget {
  static const String id = "OrderTracking";
  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  final LatLng userLocation = LatLng(10.0456, 76.4876);
  final LatLng restaurantLocation = LatLng(10.0123, 76.4567);
  LatLng? driverLocation;
  String orderStatus = "Order accepted";
  double remainingDistance = 0.0;

  Timer? locationTimer;

  @override
  void initState() {
    super.initState();
    _initLocationUpdates();
  }

  void _initLocationUpdates() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    // Start location updates every 3 seconds
    locationTimer = Timer.periodic(Duration(seconds: 3), (_) async {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        driverLocation = LatLng(position.latitude, position.longitude);
        remainingDistance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          userLocation.latitude,
          userLocation.longitude,
        );
        if (remainingDistance < 50) {
          orderStatus = "Arrived!";
        } else if (remainingDistance < 300) {
          orderStatus = "Almost there";
        } else {
          orderStatus = "On the way";
        }
      });
    });
  }

  @override
  void dispose() {
    locationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: driverLocation ?? restaurantLocation,
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              if (driverLocation != null)

            MarkerLayer(
  markers: [
    Marker(
      width: 40,
      height: 40,
      point: restaurantLocation,
      child: Icon(Icons.restaurant, color: Colors.red, size: 30),
    ),
    Marker(
      width: 40,
      height: 40,
      point: userLocation,
      child: Icon(Icons.home, color: Colors.blue, size: 30),
    ),
    Marker(
      width: 40,
      height: 40,
      point: driverLocation!,
      child: Icon(Icons.delivery_dining, color: Colors.green, size: 30),
    ),
  ],
)
            ],
          ),
          _buildOrderDetails(),
        ],
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Remaining Distance", style: TextStyle(color: Colors.white70)),
            Text(
              "${remainingDistance.toStringAsFixed(0)} meters",
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            SizedBox(height: 10),
            Text("Status: $orderStatus",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white10),
              child: Text("Track Order", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
