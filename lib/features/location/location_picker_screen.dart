import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../core/app_constants.dart';

class LocationPickerScreen extends StatefulWidget {
  final Position? initialPosition;

  const LocationPickerScreen({
    super.key,
    this.initialPosition,
  });

  @override
  State<LocationPickerScreen> createState() =>
      _LocationPickerScreenState();
}

class _LocationPickerScreenState
    extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;

  LatLng? _selectedLocation;
  String _selectedAddress = 'Move the map to select a location.';

  bool _isLoadingLocation = false;
  bool _isLoadingAddress = false;

  final Geocoding _geocoding = Geocoding();

  static const LatLng _defaultLocation = LatLng(
    20.2961,
    85.8245,
  );

  @override
  void initState() {
    super.initState();

    if (widget.initialPosition != null) {
      _selectedLocation = LatLng(
        widget.initialPosition!.latitude,
        widget.initialPosition!.longitude,
      );
    } else {
      _selectedLocation = _defaultLocation;
    }

    _reverseGeocode(_selectedLocation!);
  }

  Future<void> _onMapCreated(
      GoogleMapController controller,
      ) async {
    _mapController = controller;

    if (_selectedLocation != null) {
      await controller.animateCamera(
        CameraUpdate.newLatLngZoom(
          _selectedLocation!,
          16,
        ),
      );
    }
  }

  Future<void> _moveToCurrentLocation() async {
    if (_isLoadingLocation) {
      return;
    }

    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location services are turned off. Please enable GPS.',
            ),
          ),
        );

        return;
      }

      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permission is required.',
            ),
          ),
        );

        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permission is permanently denied. Enable it from app settings.',
            ),
          ),
        );

        return;
      }

      final position =
      await Geolocator.getCurrentPosition(
        locationSettings:
        const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final location = LatLng(
        position.latitude,
        position.longitude,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _selectedLocation = location;
      });

      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          location,
          17,
        ),
      );

      await _reverseGeocode(location);
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to detect your current location.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  Future<void> _onCameraMove(
      CameraPosition position,
      ) async {
    _selectedLocation = position.target;
  }

  Future<void> _onCameraIdle() async {
    final location = _selectedLocation;

    if (location == null) {
      return;
    }

    await _reverseGeocode(location);
  }

  Future<void> _reverseGeocode(LatLng location) async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoadingAddress = true;
    });

    try {
      final placemarks =
      await _geocoding.placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (!mounted) {
        return;
      }

      if (placemarks.isEmpty) {
        setState(() {
          _selectedAddress = 'Selected location';
        });

        return;
      }

      final place = placemarks.first;

      final parts = <String>[
        if ((place.name ?? '').trim().isNotEmpty)
          place.name!.trim(),
        if ((place.subLocality ?? '').trim().isNotEmpty)
          place.subLocality!.trim(),
        if ((place.locality ?? '').trim().isNotEmpty)
          place.locality!.trim(),
        if ((place.administrativeArea ?? '').trim().isNotEmpty)
          place.administrativeArea!.trim(),
      ];

      setState(() {
        _selectedAddress = parts.isNotEmpty
            ? parts.join(', ')
            : 'Selected location';
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _selectedAddress = 'Selected location';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingAddress = false;
        });
      }
    }
  }

  void _confirmLocation() {
    final location = _selectedLocation;

    if (location == null) {
      return;
    }

    Navigator.of(context).pop(
      LocationSelectionResult(
        latitude: location.latitude,
        longitude: location.longitude,
        address: _selectedAddress,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final location =
        _selectedLocation ?? _defaultLocation;

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Select Location',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: location,
              zoom: 16,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: true,
            mapToolbarEnabled: false,
            onMapCreated: _onMapCreated,
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
          ),

          IgnorePointer(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 38,
                ),
                child: Icon(
                  Icons.location_pin,
                  size: 54,
                  color: AppConstants.emergencyColor,
                  shadows: const [
                    Shadow(
                      color: Colors.black26,
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: 18,
            left: 18,
            right: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 13,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.12,
                    ),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    color: AppConstants.primaryColor,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Move the map and place the pin on your desired location.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            right: 18,
            bottom: 205,
            child: FloatingActionButton(
              heroTag: 'current_location',
              onPressed: _moveToCurrentLocation,
              backgroundColor: Colors.white,
              foregroundColor:
              AppConstants.primaryColor,
              elevation: 5,
              child: _isLoadingLocation
                  ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppConstants.primaryColor,
                ),
              )
                  : const Icon(
                Icons.my_location_rounded,
              ),
            ),
          ),

          Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.15,
                    ),
                    blurRadius: 20,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected Location',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppConstants.textLight,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppConstants.lightAqua,
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: AppConstants.primaryColor,
                          size: 21,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _isLoadingAddress
                            ? const Padding(
                          padding:
                          EdgeInsets.only(top: 8),
                          child: LinearProgressIndicator(
                            minHeight: 3,
                            color:
                            AppConstants.primaryColor,
                            backgroundColor:
                            AppConstants.lightAqua,
                          ),
                        )
                            : Text(
                          _selectedAddress,
                          maxLines: 3,
                          overflow:
                          TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.35,
                            fontWeight:
                            FontWeight.w700,
                            color:
                            AppConstants.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed:
                      _isLoadingAddress
                          ? null
                          : _confirmLocation,
                      icon: const Icon(
                        Icons.check_rounded,
                        size: 20,
                      ),
                      label: const Text(
                        'Confirm Location',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        AppConstants.primaryColor,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                        AppConstants.primaryColor
                            .withValues(alpha: 0.45),
                        elevation: 0,
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationSelectionResult {
  final double latitude;
  final double longitude;
  final String address;

  const LocationSelectionResult({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}