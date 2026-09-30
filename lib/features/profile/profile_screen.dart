import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../../core/app_constants.dart';
import '../auth/auth_service.dart';
import '../auth/login_screen.dart';
import '../location/location_picker_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<Map<String, dynamic>?> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return null;
    }

    final document = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!document.exists) {
      return null;
    }

    return document.data();
  }

  void _retryProfile() {
    setState(() {
      _profileFuture = _loadProfile();
    });
  }

  void _showPersonalDetails(Map<String, dynamic> profile) {
    final name = profile['name']?.toString() ?? 'Not provided';
    final age = profile['age']?.toString() ?? 'Not provided';
    final gender = profile['gender']?.toString() ?? 'Not provided';
    final bloodGroup =
        profile['bloodGroup']?.toString() ?? 'Not provided';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppConstants.backgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppConstants.borderColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withValues(
                          alpha: 0.10,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: AppConstants.primaryColor,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 13),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppConstants.textDark,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Information from your profile setup',
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
                const SizedBox(height: 22),
                _DetailRow(
                  icon: Icons.person_rounded,
                  label: 'Name',
                  value: name,
                  color: AppConstants.primaryColor,
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  icon: Icons.cake_outlined,
                  label: 'Age',
                  value: age,
                  color: AppConstants.orangeColor,
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  icon: Icons.wc_rounded,
                  label: 'Gender',
                  value: gender,
                  color: AppConstants.blueColor,
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  icon: Icons.bloodtype_outlined,
                  label: 'Blood Group',
                  value: bloodGroup,
                  color: AppConstants.emergencyColor,
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _startAddressFlow() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    Navigator.of(context).pop();

    if (!mounted) {
      return;
    }

    final result =
    await Navigator.of(context).push<LocationSelectionResult>(
      MaterialPageRoute(
        builder: (_) => const LocationPickerScreen(),
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
        _profileFuture = _loadProfile();
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

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
  _loadSavedLocations() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return [];
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('savedLocations')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs;
  }

  void _showSavedLocation(Map<String, dynamic> profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.82,
          decoration: const BoxDecoration(
            color: AppConstants.backgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppConstants.borderColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppConstants.orangeColor.withValues(
                          alpha: 0.10,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.location_on_outlined,
                        color: AppConstants.orangeColor,
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
                            'Saved Locations',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppConstants.textDark,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'All your saved addresses',
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
                Expanded(
                  child: FutureBuilder<
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                    future: _loadSavedLocations(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppConstants.primaryColor,
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                size: 44,
                                color: AppConstants.emergencyColor,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Unable to load saved locations.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppConstants.textDark,
                                ),
                              ),
                              const SizedBox(height: 16),
                              OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _showSavedLocation(profile);
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      final locations = snapshot.data ?? [];

                      if (locations.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                color: AppConstants.orangeColor
                                    .withValues(alpha: 0.10),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.location_off_outlined,
                                size: 38,
                                color: AppConstants.orangeColor,
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Text(
                              'No saved locations yet',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: AppConstants.textDark,
                              ),
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              'Add a location to quickly use it during an emergency.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                height: 1.4,
                                color: AppConstants.textLight,
                              ),
                            ),
                            const SizedBox(height: 22),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: _startAddressFlow,
                                icon: const Icon(
                                  Icons.add_location_alt_rounded,
                                ),
                                label: const Text(
                                  'Add Location',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.only(
                                bottom: 12,
                              ),
                              itemCount: locations.length,
                              separatorBuilder: (_, _) =>
                              const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final location =
                                locations[index].data();

                                return _SavedLocationCard(
                                  location: location,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: _startAddressFlow,
                              icon: const Icon(
                                Icons.add_location_alt_rounded,
                              ),
                              label: const Text(
                                'Add New Location',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                AppConstants.primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _logout() async {
    try {
      await AuthService.signOut();

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
            (route) => false,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to log out. Please try again.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppConstants.backgroundColor,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: AppConstants.backgroundColor,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Unable to load your profile.',
                      style: TextStyle(
                        color: AppConstants.textDark,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _retryProfile,
                        child: const Text('Retry'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final profile = snapshot.data;

        if (profile == null) {
          return Scaffold(
            backgroundColor: AppConstants.backgroundColor,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Profile information not found.',
                      style: TextStyle(
                        color: AppConstants.textDark,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _retryProfile,
                        child: const Text('Retry'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final name = profile['name']?.toString().trim();
        final phoneNumber =
        profile['phoneNumber']?.toString().trim();

        final displayName =
        name != null && name.isNotEmpty
            ? name
            : 'PranProhor User';

        final displayPhone =
        phoneNumber != null && phoneNumber.isNotEmpty
            ? phoneNumber
            : 'Mobile number not available';

        return _buildProfileScreen(
          context,
          profile,
          displayName,
          displayPhone,
        );
      },
    );
  }

  Widget _buildProfileScreen(
      BuildContext context,
      Map<String, dynamic> profile,
      String displayName,
      String displayPhone,
      ) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            16,
            20,
            100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PranProhor',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppConstants.textLight,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppConstants.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: AppConstants.textDark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppConstants.primaryDark,
                      AppConstants.primaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.primaryColor.withValues(
                        alpha: 0.20,
                      ),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(
                            alpha: 0.7,
                          ),
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 40,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            displayPhone,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                size: 15,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Patient Account',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: AppConstants.textDark,
                ),
              ),
              const SizedBox(height: 12),
              _ProfileOption(
                icon: Icons.person_outline_rounded,
                title: 'Personal Details',
                subtitle:
                'View your name and basic information',
                color: AppConstants.primaryColor,
                onTap: () {
                  _showPersonalDetails(profile);
                },
              ),
              const SizedBox(height: 10),
              _ProfileOption(
                icon: Icons.location_on_outlined,
                title: 'Saved Location',
                subtitle:
                'Manage your saved addresses',
                color: AppConstants.orangeColor,
                onTap: () {
                  _showSavedLocation(profile);
                },
              ),
              const SizedBox(height: 28),
              const Text(
                'Emergency',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: AppConstants.textDark,
                ),
              ),
              const SizedBox(height: 12),
              _ProfileOption(
                icon: Icons.contact_emergency_outlined,
                title: 'Emergency Contacts',
                subtitle:
                'People to contact during an emergency',
                color: AppConstants.emergencyColor,
                onTap: () {},
              ),
              const SizedBox(height: 10),
              _ProfileOption(
                icon: Icons.medical_information_outlined,
                title: 'Medical Information',
                subtitle:
                'Important information for emergency care',
                color: AppConstants.emergencyColor,
                onTap: () {},
              ),
              const SizedBox(height: 28),
              const Text(
                'Account',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: AppConstants.textDark,
                ),
              ),
              const SizedBox(height: 12),
              _ProfileOption(
                icon: Icons.notifications_none_rounded,
                title: 'Notifications',
                subtitle:
                'Manage emergency and app notifications',
                color: AppConstants.primaryColor,
                onTap: () {},
              ),
              const SizedBox(height: 10),
              _ProfileOption(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy & Security',
                subtitle:
                'Manage your account privacy',
                color: AppConstants.blueColor,
                onTap: () {},
              ),
              const SizedBox(height: 10),
              _ProfileOption(
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
                subtitle:
                'Get help with PranProhor',
                color: AppConstants.orangeColor,
                onTap: () {},
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(
                    Icons.logout_rounded,
                    size: 20,
                  ),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                    AppConstants.emergencyColor,
                    side: BorderSide(
                      color:
                      AppConstants.emergencyColor.withValues(
                        alpha: 0.35,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'জীবনের পাশে, প্রতিটি প্রহরে',
                        style: TextStyle(
                          fontSize: 16,
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

class _AddressFormSheetState extends State<_AddressFormSheet> {
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      color: AppConstants.primaryColor.withValues(
                        alpha: 0.10,
                      ),
                      borderRadius: BorderRadius.circular(15),
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
                  borderRadius: BorderRadius.circular(16),
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
                              fontWeight: FontWeight.w600,
                              color: AppConstants.textLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.detectedAddress,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppConstants.textDark,
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
                hint: 'e.g. Flat 3B, ABC Apartments',
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
                      selected: _selectedLabel == 'Home',
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
                      selected: _selectedLabel == 'Office',
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
                      selected: _selectedLabel == 'Other',
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
                  onPressed: _isSaving ? null : _handleSave,
                  icon: _isSaving
                      ? const SizedBox(
                    width: 21,
                    height: 21,
                    child: CircularProgressIndicator(
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
                    AppConstants.primaryColor.withValues(
                      alpha: 0.55,
                    ),
                    disabledForegroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
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
                    foregroundColor: AppConstants.textDark,
                    disabledForegroundColor:
                    AppConstants.textLight,
                    side: const BorderSide(
                      color: AppConstants.borderColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
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

class _SavedLocationCard extends StatelessWidget {
  final Map<String, dynamic> location;

  const _SavedLocationCard({
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final label =
        location['label']?.toString().trim() ?? 'Other';

    final address =
        location['address']?.toString().trim() ?? '';

    final house =
        location['house']?.toString().trim() ?? '';

    final road =
        location['road']?.toString().trim() ?? '';

    final landmark =
        location['landmark']?.toString().trim() ?? '';

    final displayAddress = address.isNotEmpty
        ? address
        : [
      if (house.isNotEmpty) house,
      if (road.isNotEmpty) road,
      if (landmark.isNotEmpty) landmark,
    ].join(', ');

    final icon = label == 'Home'
        ? Icons.home_rounded
        : label == 'Office'
        ? Icons.business_rounded
        : Icons.location_on_rounded;

    final color = label == 'Home'
        ? AppConstants.primaryColor
        : label == 'Office'
        ? AppConstants.blueColor
        : AppConstants.orangeColor;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: AppConstants.borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: color,
              size: 23,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  displayAddress.isNotEmpty
                      ? displayAddress
                      : 'Address details not available',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
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
              ? AppConstants.primaryColor.withValues(alpha: 0.10)
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
                fontWeight:
                selected
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

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppConstants.borderColor,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppConstants.textDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.3,
                      color: AppConstants.textLight,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppConstants.textLight,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: AppConstants.borderColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppConstants.textLight,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppConstants.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}