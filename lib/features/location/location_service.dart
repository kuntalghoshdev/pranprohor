import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._();

  static Future<bool> isServiceEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  static Future<LocationPermission> checkPermission() async {
    return Geolocator.checkPermission();
  }

  static Future<LocationPermission> requestPermission() async {
    return Geolocator.requestPermission();
  }

  static Future<Position> getCurrentPosition() async {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  static Future<bool> openAppSettings() async {
    return Geolocator.openAppSettings();
  }

  static Future<bool> openLocationSettings() async {
    return Geolocator.openLocationSettings();
  }

  static Future<Position?> getLocation() async {
    final serviceEnabled = await isServiceEnabled();

    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    return getCurrentPosition();
  }
}