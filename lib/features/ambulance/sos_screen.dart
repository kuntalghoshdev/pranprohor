import 'package:flutter/material.dart';

import '../../core/app_constants.dart';

class SosScreen extends StatelessWidget {
  const SosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Emergency SOS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Emergency icon
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: AppConstants.emergencyLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppConstants.emergencyColor.withValues(
                      alpha: 0.2,
                    ),
                    width: 8,
                  ),
                ),
                child: const Icon(
                  Icons.sos_rounded,
                  size: 52,
                  color: AppConstants.emergencyColor,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Emergency Assistance',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppConstants.textDark,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'PranProhor will help coordinate emergency '
                    'assistance near your current location.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppConstants.textLight,
                ),
              ),

              const SizedBox(height: 24),

              // Location card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppConstants.borderColor,
                  ),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 23,
                      backgroundColor: AppConstants.lightAqua,
                      child: Icon(
                        Icons.location_on_rounded,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Location',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppConstants.textLight,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Location will be detected',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.my_location_rounded,
                      color: AppConstants.primaryColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // What SOS will do
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppConstants.softTeal,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'What happens after SOS?',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.textDark,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _SosActionRow(
                      icon: Icons.location_on_rounded,
                      title: 'Share your location',
                      subtitle: 'Your emergency location will be identified.',
                    ),
                    const SizedBox(height: 12),
                    _SosActionRow(
                      icon: Icons.local_shipping_rounded,
                      title: 'Find emergency assistance',
                      subtitle: 'Nearby ambulance options can be identified.',
                    ),
                    const SizedBox(height: 12),
                    _SosActionRow(
                      icon: Icons.local_hospital_rounded,
                      title: 'Find suitable hospitals',
                      subtitle: 'Nearby healthcare resources can be checked.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // SOS button
              SizedBox(
                width: double.infinity,
                height: 62,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.sos_rounded,
                    size: 28,
                  ),
                  label: const Text(
                    'ACTIVATE SOS',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.emergencyColor,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shadowColor:
                    AppConstants.emergencyColor.withValues(alpha: 0.35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppConstants.textLight,
                    fontWeight: FontWeight.w600,
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

class _SosActionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SosActionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppConstants.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.35,
                  color: AppConstants.textLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}