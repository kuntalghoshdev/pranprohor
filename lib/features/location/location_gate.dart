import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/app_constants.dart';
import '../home/main_navigation_screen.dart';
import 'location_service.dart';

class LocationGate extends StatefulWidget {
  const LocationGate({super.key});

  @override
  State<LocationGate> createState() => _LocationGateState();
}

class _LocationGateState extends State<LocationGate> {
  bool _isLoading = true;
  String? _errorMessage;
  bool _locationServiceDisabled = false;
  bool _permissionDeniedForever = false;

  Position? _position;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _locationServiceDisabled = false;
      _permissionDeniedForever = false;
    });

    try {
      final serviceEnabled = await LocationService.isServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
          _locationServiceDisabled = true;
          _errorMessage =
          'Location services are turned off. Please enable location to continue.';
        });

        return;
      }

      LocationPermission permission =
      await LocationService.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await LocationService.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
          _errorMessage =
          'Location permission is required to continue.';
        });

        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
          _permissionDeniedForever = true;
          _errorMessage =
          'Location permission is permanently denied. Please enable it from app settings.';
        });

        return;
      }

      final position = await LocationService.getCurrentPosition();

      if (!mounted) return;

      setState(() {
        _position = position;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage =
        'Unable to get your location. Please try again.';
      });
    }
  }

  Future<void> _openSettings() async {
    if (_permissionDeniedForever) {
      await LocationService.openAppSettings();
    } else {
      await LocationService.openLocationSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: AppConstants.primaryColor,
                ),
                SizedBox(height: 20),
                Text(
                  'Getting your location...',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_position != null) {
      return MainNavigationScreen(
        position: _position,
      );
    }

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppConstants.lightAqua,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    size: 48,
                    color: AppConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Location Access',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    color: AppConstants.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'PranProhor uses your location to provide '
                      'nearby healthcare and emergency assistance.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: AppConstants.textLight,
                  ),
                ),
                const SizedBox(height: 20),
                if (_errorMessage != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppConstants.emergencyColor.withValues(
                        alpha: 0.08,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.emergencyColor,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _initializeLocation,
                    icon: const Icon(
                      Icons.location_searching_rounded,
                    ),
                    label: const Text(
                      'Allow Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                if (_locationServiceDisabled ||
                    _permissionDeniedForever) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _openSettings,
                      child: Text(
                        _permissionDeniedForever
                            ? 'Open App Settings'
                            : 'Open Location Settings',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}