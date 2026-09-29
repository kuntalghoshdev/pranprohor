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

  static Future<bool> openAppSettings() async {
    return Geolocator.openAppSettings();
  }

  static Future<bool> openLocationSettings() async {
    return Geolocator.openLocationSettings();
  }

  /// Gets a fresh, high-accuracy GPS position.
  ///
  /// We intentionally do not use the last known location here because
  /// PranProhor needs the user's current position for emergency services,
  /// nearby hospitals and saved-location detection.
  static Future<Position> getCurrentPosition() async {
    final serviceEnabled = await isServiceEnabled();

    if (!serviceEnabled) {
      throw const LocationServiceDisabledException();
    }

    LocationPermission permission = await checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const PermissionDeniedException(
        'Location permission was denied.',
      );
    }

    if (permission == LocationPermission.deniedForever) {
      throw const PermissionDeniedException(
        'Location permission is permanently denied.',
      );
    }

    Position? bestPosition;

    for (int attempt = 0; attempt < 3; attempt++) {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 20),
        ),
      );

      bestPosition = position;

      if (position.accuracy <= 50) {
        return position;
      }

      await Future<void>.delayed(
        const Duration(milliseconds: 700),
      );
    }

    if (bestPosition != null) {
      return bestPosition;
    }

    throw const LocationServiceDisabledException();
  }

  static Future<Position?> getLocation() async {
    try {
      return await getCurrentPosition();
    } catch (_) {
      return null;
    }
  }
}