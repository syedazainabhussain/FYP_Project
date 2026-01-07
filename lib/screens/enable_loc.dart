import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'homescreen.dart'; 
import 'authentication/user_session.dart'; 

class EnableLocationScreen extends StatefulWidget {
  const EnableLocationScreen({super.key});

  @override
  State<EnableLocationScreen> createState() => _EnableLocationScreenState();
}

class _EnableLocationScreenState extends State<EnableLocationScreen> {
  bool _isLoading = false;
  String _statusMessage = 'Allow location access to continue using the app.';

  Future<void> _updateLocationOnServer(double lat, double lng) async {
    final url = Uri.parse("https://mechanicapp-service-621632382478.asia-south1.run.app/api/current/location");

    try {
      final response = await http.post(
        url,
        headers: UserSession().getAuthHeader(), 
        body: jsonEncode({
          "latitude": lat,
          "longitude": lng,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint("✅ Location updated on server");
      } else {
        debugPrint("❌ Server Error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ Network Error: $e");
    }
  }

  Future<void> handleLocationPermission() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "Checking permissions...";
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        setState(() => _isLoading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar("Location permission denied");
          setState(() => _isLoading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar("Permissions permanently denied. Please enable them in settings.");
        setState(() => _isLoading = false);
        return;
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        setState(() => _statusMessage = "Getting location...");

        Position? position;
        try {
          position = await Geolocator.getLastKnownPosition();
          position = await Geolocator.getCurrentPosition(
            locationSettings:  AndroidSettings(
              accuracy: LocationAccuracy.high,
              forceLocationManager: false, 
            ),
          ).timeout(const Duration(seconds: 10));
        } catch (e) {
          debugPrint("Primary location fetch failed: $e. Trying fallback...");
          try {
            position = await Geolocator.getCurrentPosition(
              locationSettings:  AndroidSettings(
                accuracy: LocationAccuracy.low,
                forceLocationManager: true,
              ),
            ).timeout(const Duration(seconds: 15));
          } catch (fallbackError) {
            debugPrint("Fallback location fetch failed: $fallbackError");
          }
        }

        if (position != null) {
          setState(() => _statusMessage = "Saving location...");
          await _updateLocationOnServer(position.latitude, position.longitude);

          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        } else {
          _showSnackBar("Could not get location. Ensure GPS is on and you are in an open area.");
        }
      }
    } catch (e) {
      _showSnackBar("Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.white70 : Colors.black54;
    final buttonColor = const Color(0xFFFB3300);

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on_rounded, size: 90, color: buttonColor),
              const SizedBox(height: 20),
              Text('Enable Location', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: textColor)),
              const SizedBox(height: 12),
              Text(_statusMessage, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: hintColor)),
              const SizedBox(height: 35),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : handleLocationPermission,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Allow', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
