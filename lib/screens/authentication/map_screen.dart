// map_screen.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final String serviceType;

  const MapScreen({super.key, required this.serviceType});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // ignore: unused_field
  late GoogleMapController _mapController;

  final LatLng _center = const LatLng(24.8607, 67.0011); // Karachi dummy

  late Set<Marker> _markers;

  @override
  void initState() {
    super.initState();
    _loadDummyMechanics();
  }

  void _loadDummyMechanics() {
    _markers = {
      Marker(
        markerId: const MarkerId('m1'),
        position: const LatLng(24.8615, 67.0025),
        infoWindow: InfoWindow(
          title: "${widget.serviceType} Mechanic",
          snippet: "1.2 km away",
        ),
      ),
      Marker(
        markerId: const MarkerId('m2'),
        position: const LatLng(24.8580, 67.0002),
        infoWindow: InfoWindow(
          title: "${widget.serviceType} Mechanic",
          snippet: "2.0 km away",
        ),
      ),
      Marker(
        markerId: const MarkerId('m3'),
        position: const LatLng(24.8640, 67.0060),
        infoWindow: InfoWindow(
          title: "${widget.serviceType} Mechanic",
          snippet: "2.8 km away",
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.serviceType} Nearby Mechanics"),
        backgroundColor: const Color(0xFFFB3300),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 13,
        ),
        markers: _markers,
        onMapCreated: (controller) {
          _mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}
