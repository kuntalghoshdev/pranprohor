import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/app_constants.dart';
import '../ambulance/sos_screen.dart';
import '../location/location_picker_screen.dart';
import '../notifications/notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  final Position? position;

  const HomeScreen({
    super.key,
    this.position,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _placeName = 'Detecting your location...';
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();

    _currentPosition = widget.position;
    _getPlaceName();
  }

  Future<void> _getPlaceName() async {
    final position = _currentPosition;

    if (position == null) {
      if (mounted) {
        setState(() {
          _placeName = 'Location not available';
        });
      }
      return;
    }

    try {
      final geocoding = Geocoding();

      final placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (!mounted || placemarks.isEmpty) {
        return;
      }

      final place = placemarks.first;

      final parts = <String>[
        if (place.subLocality != null &&
            place.subLocality!.trim().isNotEmpty)
          place.subLocality!.trim(),
        if (place.locality != null &&
            place.locality!.trim().isNotEmpty)
          place.locality!.trim(),
      ];

      if (parts.isNotEmpty) {
        setState(() {
          _placeName = parts.join(', ');
        });
      } else if (place.administrativeArea != null &&
          place.administrativeArea!.trim().isNotEmpty) {
        setState(() {
          _placeName = place.administrativeArea!.trim();
        });
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _placeName = 'Unable to detect location';
      });
    }
  }

  Future<void> _changeLocation() async {
    final result =
    await Navigator.of(context).push<LocationSelectionResult>(
      MaterialPageRoute(
        builder: (_) => LocationPickerScreen(
          initialPosition: _currentPosition,
        ),
      ),
    );

    if (!mounted || result == null) {
      return;
    }

    await _showAddressForm(
      latitude: result.latitude,
      longitude: result.longitude,
      detectedAddress: result.address,
    );
  }

  Future<void> _showAddressForm({
    required double latitude,
    required double longitude,
    required String detectedAddress,
  }) async {
    String address = detectedAddress;

    if (address.trim().isEmpty) {
      address = 'Selected location';
    }

    if (address == 'Selected location') {
      try {
        final geocoding = Geocoding();

        final placemarks =
        await geocoding.placemarkFromCoordinates(
          latitude,
          longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;

          final parts = <String>[
            if ((place.name ?? '').trim().isNotEmpty)
              place.name!.trim(),
            if ((place.locality ?? '').trim().isNotEmpty)
              place.locality!.trim(),
            if ((place.administrativeArea ?? '').trim().isNotEmpty)
              place.administrativeArea!.trim(),
          ];

          if (parts.isNotEmpty) {
            address = parts.join(', ');
          }
        }
      } catch (_) {
        // Keep fallback address.
      }
    }

    if (!mounted) {
      return;
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _AddressFormSheet(
          latitude: latitude,
          longitude: longitude,
          detectedAddress: address,
          onSave: ({
            required double latitude,
            required double longitude,
            required String detectedAddress,
            required String house,
            required String road,
            required String landmark,
            required String label,
          }) async {
            await _saveAddress(
              latitude: latitude,
              longitude: longitude,
              detectedAddress: detectedAddress,
              house: house,
              road: road,
              landmark: landmark,
              label: label,
            );
          },
        );
      },
    );
  }

  Future<void> _saveAddress({
    required double latitude,
    required double longitude,
    required String detectedAddress,
    required String house,
    required String road,
    required String landmark,
    required String label,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saving your address...'),
      ),
    );

    final addressParts = <String>[
      if (house.isNotEmpty) house,
      if (road.isNotEmpty) road,
      if (landmark.isNotEmpty) landmark,
      if (detectedAddress.isNotEmpty) detectedAddress,
    ];

    final address = addressParts.join(', ');

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('savedLocations')
          .add({
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'house': house,
        'road': road,
        'landmark': landmark,
        'label': label,
        'detectedAddress': detectedAddress,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) {
        return;
      }

      setState(() {
        _placeName = detectedAddress;
        _currentPosition = Position(
          longitude: longitude,
          latitude: latitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Address saved successfully.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to save your address. Please try again.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppConstants.lightAqua,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      AppConstants.logoPath,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello 👋',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppConstants.textLight,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Welcome to PranProhor',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.textDark,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          AppConstants.tagline,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppConstants.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Notification button with unread badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                const NotificationsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            color: AppConstants.textDark,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppConstants.emergencyColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Location
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: AppConstants.lightAqua,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: AppConstants.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Location',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppConstants.textLight,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _placeName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: _changeLocation,
                      child: const Text('Change'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Emergency Hero Card
              Container(
                width: double.infinity,
                height: 245,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color:
                      AppConstants.emergencyColor.withValues(
                        alpha: 0.18,
                      ),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/home/emergency_banner.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              AppConstants.primaryDark.withValues(
                                alpha: 0.96,
                              ),
                              AppConstants.primaryDark.withValues(
                                alpha: 0.82,
                              ),
                              AppConstants.primaryDark.withValues(
                                alpha: 0.20,
                              ),
                              Colors.transparent,
                            ],
                            stops: const [
                              0.0,
                              0.42,
                              0.72,
                              1.0,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 5,
                        height: 245,
                        decoration: const BoxDecoration(
                          color: AppConstants.emergencyColor,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 18,
                      left: 18,
                      right: 18,
                      bottom: 70,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'EMERGENCY',
                              style: TextStyle(
                                color:
                                AppConstants.emergencyColor,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Get Help',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 27,
                              height: 1.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Text(
                            'Now!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 27,
                              height: 1.05,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Ambulance • Hospitals\n'
                                'Blood • Emergency Support',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 14,
                      right: 14,
                      bottom: 12,
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                const SosScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.sos_rounded,
                            size: 21,
                          ),
                          label: const Text(
                            'SOS • GET EMERGENCY HELP',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            AppConstants.emergencyColor,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shadowColor:
                            AppConstants.emergencyColor
                                .withValues(alpha: 0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Quick Services heading
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Quick Services',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textDark,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('See All'),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Service cards
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics:
                const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.95,
                children: [
                  _ServiceCard(
                    imageUrl:
                    'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=300&q=80',
                    icon: Icons.local_hospital_rounded,
                    title: 'Nearby\nHospitals',
                    color: AppConstants.blueColor,
                    onTap: () {},
                  ),
                  _ServiceCard(
                    imageUrl:
                    'https://images.unsplash.com/photo-1587745416684-47953f16f02f?auto=format&fit=crop&w=300&q=80',
                    icon: Icons.local_shipping_rounded,
                    title: 'Book\nAmbulance',
                    color: AppConstants.emergencyColor,
                    onTap: () {},
                  ),
                  _ServiceCard(
                    imageUrl:
                    'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?auto=format&fit=crop&w=300&q=80',
                    icon: Icons.water_drop_rounded,
                    title: 'Blood\nAvailability',
                    color: AppConstants.emergencyColor,
                    onTap: () {},
                  ),
                  _ServiceCard(
                    imageUrl:
                    'https://images.unsplash.com/photo-1559757175-0eb30cd8c063?auto=format&fit=crop&w=300&q=80',
                    icon: Icons.medical_services_rounded,
                    title: 'Medical\nCheckup',
                    color: AppConstants.primaryColor,
                    onTap: () {},
                  ),
                  _ServiceCard(
                    imageUrl:
                    'https://images.unsplash.com/photo-1584515933487-779824d29309?auto=format&fit=crop&w=300&q=80',
                    icon: Icons.health_and_safety_rounded,
                    title: 'Health\nResources',
                    color: AppConstants.primaryColor,
                    onTap: () {},
                  ),
                  _ServiceCard(
                    imageUrl:
                    'https://images.unsplash.com/photo-1584515933487-779824d29309?auto=format&fit=crop&w=300&q=80',
                    icon: Icons.call_rounded,
                    title: 'Emergency\nContacts',
                    color: AppConstants.orangeColor,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 26),

              // Nearby Hospitals
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Nearby Hospitals',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textDark,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View Map'),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                height: 190,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: AppConstants.lightAqua,
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1586773860418-d37222d8fce3?auto=format&fit=crop&w=900&q=80',
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) {
                          return Container(
                            color: AppConstants.lightAqua,
                          );
                        },
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppConstants.textDark.withValues(
                                alpha: 0.85,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      left: 18,
                      right: 18,
                      bottom: 16,
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Find verified hospitals near you',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Tagline card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppConstants.softTeal,
                      AppConstants.lightAqua,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      color: AppConstants.orangeColor,
                      size: 30,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'জীবনের পাশে, প্রতিটি প্রহরে',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressFormSheet extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String detectedAddress;

  final Future<void> Function({
  required double latitude,
  required double longitude,
  required String detectedAddress,
  required String house,
  required String road,
  required String landmark,
  required String label,
  }) onSave;

  const _AddressFormSheet({
    required this.latitude,
    required this.longitude,
    required this.detectedAddress,
    required this.onSave,
  });

  @override
  State<_AddressFormSheet> createState() =>
      _AddressFormSheetState();
}

class _AddressFormSheetState
    extends State<_AddressFormSheet> {
  late final TextEditingController _houseController;
  late final TextEditingController _roadController;
  late final TextEditingController _landmarkController;

  String _selectedLabel = 'Home';
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _houseController = TextEditingController();
    _roadController = TextEditingController();
    _landmarkController = TextEditingController();
  }

  @override
  void dispose() {
    _houseController.dispose();
    _roadController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_isSaving) {
      return;
    }

    final house = _houseController.text.trim();
    final road = _roadController.text.trim();
    final landmark = _landmarkController.text.trim();

    if (house.isEmpty || road.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your house/flat and road details.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await widget.onSave(
        latitude: widget.latitude,
        longitude: widget.longitude,
        detectedAddress: widget.detectedAddress,
        house: house,
        road: road,
        landmark: landmark,
        label: _selectedLabel,
      );

      if (!mounted) {
        return;
      }

      Navigator.pop(context);
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: AppConstants.backgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppConstants.borderColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor
                          .withValues(alpha: 0.10),
                      borderRadius:
                      BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.edit_location_alt_rounded,
                      color: AppConstants.primaryColor,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 13),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Address Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppConstants.textDark,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'Confirm your address for emergencies',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppConstants.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppConstants.lightAqua,
                  borderRadius:
                  BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.my_location_rounded,
                      color: AppConstants.primaryColor,
                      size: 22,
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Detected location',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight:
                              FontWeight.w600,
                              color:
                              AppConstants.textLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.detectedAddress,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight:
                              FontWeight.w700,
                              color:
                              AppConstants.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Address details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppConstants.textDark,
                ),
              ),
              const SizedBox(height: 12),
              _AddressTextField(
                controller: _houseController,
                label: 'House / Flat / Building',
                hint:
                'e.g. Flat 3B, ABC Apartments',
                icon: Icons.home_outlined,
              ),
              const SizedBox(height: 12),
              _AddressTextField(
                controller: _roadController,
                label: 'Road / Street',
                hint: 'e.g. Janpath Road',
                icon: Icons.signpost_outlined,
              ),
              const SizedBox(height: 12),
              _AddressTextField(
                controller: _landmarkController,
                label: 'Landmark',
                hint: 'e.g. Near City Hospital',
                icon: Icons.place_outlined,
              ),
              const SizedBox(height: 22),
              const Text(
                'Save as',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppConstants.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _LocationLabelButton(
                      icon: Icons.home_rounded,
                      label: 'Home',
                      selected:
                      _selectedLabel == 'Home',
                      onTap: () {
                        setState(() {
                          _selectedLabel = 'Home';
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _LocationLabelButton(
                      icon: Icons.business_rounded,
                      label: 'Office',
                      selected:
                      _selectedLabel == 'Office',
                      onTap: () {
                        setState(() {
                          _selectedLabel = 'Office';
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _LocationLabelButton(
                      icon: Icons.location_on_rounded,
                      label: 'Other',
                      selected:
                      _selectedLabel == 'Other',
                      onTap: () {
                        setState(() {
                          _selectedLabel = 'Other';
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed:
                  _isSaving ? null : _handleSave,
                  icon: _isSaving
                      ? const SizedBox(
                    width: 21,
                    height: 21,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(
                    Icons.check_rounded,
                    size: 21,
                  ),
                  label: Text(
                    _isSaving
                        ? 'Saving Address...'
                        : 'Save Address',
                    style: const TextStyle(
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
                        .withValues(alpha: 0.55),
                    disabledForegroundColor:
                    Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: _isSaving
                      ? null
                      : () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                    AppConstants.textDark,
                    disabledForegroundColor:
                    AppConstants.textLight,
                    side: const BorderSide(
                      color: AppConstants.borderColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;

  const _AddressTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: AppConstants.primaryColor,
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(
          color: AppConstants.textLight,
        ),
        hintStyle: const TextStyle(
          color: AppConstants.textLight,
          fontSize: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppConstants.borderColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppConstants.borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppConstants.primaryColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

class _LocationLabelButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LocationLabelButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 74,
        decoration: BoxDecoration(
          color: selected
              ? AppConstants.primaryColor
              .withValues(alpha: 0.10)
              : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected
                ? AppConstants.primaryColor
                : AppConstants.borderColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 23,
              color: selected
                  ? AppConstants.primaryColor
                  : AppConstants.textLight,
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected
                    ? FontWeight.w800
                    : FontWeight.w600,
                color: selected
                    ? AppConstants.primaryColor
                    : AppConstants.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String imageUrl;
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.imageUrl,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color:
              Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 62,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return Container(
                    color: color.withValues(alpha: 0.08),
                  );
                },
              ),
            ),
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white.withValues(
                  alpha: 0.96,
                ),
              ),
            ),
            Positioned(
              top: 38,
              left: 0,
              right: 0,
              child: Icon(
                icon,
                size: 27,
                color: color,
              ),
            ),
            Positioned(
              left: 4,
              right: 4,
              bottom: 12,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.25,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}