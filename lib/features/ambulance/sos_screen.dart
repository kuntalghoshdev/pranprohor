import 'package:flutter/material.dart';

import '../../core/app_constants.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  bool _sosActivated = false;

  Future<void> _showSosConfirmation() async {
    final shouldActivate = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
          actionsPadding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          title: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppConstants.emergencyLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.sos_rounded,
                  color: AppConstants.emergencyColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Activate SOS?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppConstants.textDark,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'This will start an emergency assistance request using your current location.',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppConstants.textLight,
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppConstants.textDark,
                side: const BorderSide(
                  color: AppConstants.borderColor,
                ),
                minimumSize: const Size(100, 46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.emergencyColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(110, 46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: const Text(
                'Confirm SOS',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted || shouldActivate != true) {
      return;
    }

    setState(() {
      _sosActivated = true;
    });
  }

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
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: _sosActivated
                      ? AppConstants.softTeal
                      : AppConstants.emergencyLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _sosActivated
                        ? AppConstants.primaryColor.withValues(alpha: 0.2)
                        : AppConstants.emergencyColor.withValues(alpha: 0.2),
                    width: 8,
                  ),
                ),
                child: Icon(
                  _sosActivated
                      ? Icons.check_rounded
                      : Icons.sos_rounded,
                  size: 52,
                  color: _sosActivated
                      ? AppConstants.primaryColor
                      : AppConstants.emergencyColor,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                _sosActivated
                    ? 'SOS Activated'
                    : 'Emergency Assistance',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppConstants.textDark,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                _sosActivated
                    ? 'Your emergency request has been activated. '
                    'The next steps will be connected to the emergency system.'
                    : 'PranProhor will help coordinate emergency '
                    'assistance near your current location.',
                textAlign: TextAlign.center,
                style: const TextStyle(
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
                      subtitle:
                      'Your emergency location will be identified.',
                    ),
                    const SizedBox(height: 12),
                    _SosActionRow(
                      icon: Icons.local_shipping_rounded,
                      title: 'Find emergency assistance',
                      subtitle:
                      'Nearby ambulance options can be identified.',
                    ),
                    const SizedBox(height: 12),
                    _SosActionRow(
                      icon: Icons.local_hospital_rounded,
                      title: 'Find suitable hospitals',
                      subtitle:
                      'Nearby healthcare resources can be checked.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // SOS button / activated state
              if (!_sosActivated)
                SizedBox(
                  width: double.infinity,
                  height: 62,
                  child: ElevatedButton.icon(
                    onPressed: _showSosConfirmation,
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
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppConstants.softTeal,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppConstants.primaryColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: AppConstants.successColor,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Emergency request activated',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppConstants.textDark,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Emergency services will be connected here.',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppConstants.textLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  _sosActivated ? 'Close' : 'Cancel',
                  style: const TextStyle(
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