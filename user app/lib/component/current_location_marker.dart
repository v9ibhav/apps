import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';

class CurrentLocationMarker extends StatefulWidget {
  @override
  _CurrentLocationMarkerState createState() => _CurrentLocationMarkerState();
}

class _CurrentLocationMarkerState extends State<CurrentLocationMarker> {
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) return Container();

    return Positioned(
      left: _currentPosition!.latitude,
      top: _currentPosition!.longitude,
      child: Lottie.asset(
        'assets/lottie/wave_indicator.json',
        width: 50,
        height: 50,
      ),
    );
  }
}
