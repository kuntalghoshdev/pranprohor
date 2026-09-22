import 'package:flutter/material.dart';

import '../../core/app_constants.dart';
import '../ambulance/sos_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Location',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppConstants.textLight,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Detecting your location...',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
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
                      color: AppConstants.emergencyColor.withValues(
                        alpha: 0.18,
                      ),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Full background image
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/home/emergency_banner.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),

                    // Dark gradient for readable text
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

                    // Red emergency accent
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

                    // Content
                    Positioned(
                      top: 18,
                      left: 18,
                      right: 18,
                      bottom: 70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'EMERGENCY',
                              style: TextStyle(
                                color: AppConstants.emergencyColor,
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
                            'Ambulance • Hospitals\nBlood • Emergency Support',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SOS button
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
                                builder: (_) => const SosScreen(),
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
                            AppConstants.emergencyColor.withValues(
                              alpha: 0.4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
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
                physics: const NeverScrollableScrollPhysics(),
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
                      color: AppConstants.primaryColor,
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

      // Bottom Navigation
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor,
            borderRadius: BorderRadius.circular(36),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // Home
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home_rounded,
                  label: 'Home',
                  selected: true,
                  onTap: () {},
                ),
              ),

              // Services
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.grid_view_rounded,
                  selectedIcon: Icons.grid_view_rounded,
                  label: 'Services',
                  selected: false,
                  onTap: () {},
                ),
              ),

              // History
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.bar_chart_outlined,
                  selectedIcon: Icons.bar_chart_rounded,
                  label: 'History',
                  selected: false,
                  onTap: () {},
                ),
              ),

              // Profile
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.person_outline_rounded,
                  selectedIcon: Icons.person_rounded,
                  label: 'Profile',
                  selected: false,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            width: 56,
            height: 52,
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  selected ? selectedIcon : icon,
                  size: 23,
                  color: selected
                      ? AppConstants.orangeColor
                      : Colors.white.withValues(alpha: 0.78),
                ),
                const SizedBox(height: 2),
                if (selected)
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: AppConstants.textDark,
                    ),
                  ),
              ],
            ),
          ),
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
              color: Colors.black.withValues(alpha: 0.04),
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
                color: Colors.white.withValues(alpha: 0.96),
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