import 'package:flutter/material.dart';

import '../../core/app_constants.dart';
import '../ambulance/sos_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

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
                          'PranProhor',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppConstants.textLight,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Services',
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
                        Icons.notifications_none_rounded,
                        color: AppConstants.textDark,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Intro
              const Text(
                'How can we help?',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppConstants.textDark,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Access emergency support and healthcare services from one place.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.45,
                  color: AppConstants.textLight,
                ),
              ),

              const SizedBox(height: 22),

              // Emergency service card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
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
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppConstants.emergencyColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.sos_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Need emergency help?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Get coordinated emergency assistance quickly.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SosScreen(),
                          ),
                        );
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      icon: const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppConstants.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Healthcare services
              const Text(
                'Healthcare Services',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: AppConstants.textDark,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Everything you need for faster healthcare access.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppConstants.textLight,
                ),
              ),

              const SizedBox(height: 14),

              // Service grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.08,
                children: [
                  _ServiceTile(
                    icon: Icons.local_hospital_rounded,
                    title: 'Nearby Hospitals',
                    subtitle: 'Find hospitals near you',
                    color: AppConstants.blueColor,
                    onTap: () {},
                  ),
                  _ServiceTile(
                    icon: Icons.local_shipping_rounded,
                    title: 'Book Ambulance',
                    subtitle: 'Request emergency transport',
                    color: AppConstants.emergencyColor,
                    onTap: () {},
                  ),
                  _ServiceTile(
                    icon: Icons.water_drop_rounded,
                    title: 'Blood Availability',
                    subtitle: 'Check blood resources',
                    color: AppConstants.emergencyColor,
                    onTap: () {},
                  ),
                  _ServiceTile(
                    icon: Icons.medical_services_rounded,
                    title: 'Medical Checkup',
                    subtitle: 'Explore healthcare support',
                    color: AppConstants.primaryColor,
                    onTap: () {},
                  ),
                  _ServiceTile(
                    icon: Icons.health_and_safety_rounded,
                    title: 'Health Resources',
                    subtitle: 'Useful health information',
                    color: AppConstants.primaryColor,
                    onTap: () {},
                  ),
                  _ServiceTile(
                    icon: Icons.call_rounded,
                    title: 'Emergency Contacts',
                    subtitle: 'Important numbers',
                    color: AppConstants.orangeColor,
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Quick emergency section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppConstants.emergencyLight,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: AppConstants.emergencyColor.withValues(
                      alpha: 0.10,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: AppConstants.emergencyColor,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'In an emergency',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppConstants.textDark,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Use SOS to start emergency assistance.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppConstants.textLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SosScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'SOS',
                        style: TextStyle(
                          color: AppConstants.emergencyColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Tagline
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

class _ServiceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ServiceTile({
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
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: color,
                size: 25,
              ),
            ),
            const Spacer(),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppConstants.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                height: 1.3,
                color: AppConstants.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}