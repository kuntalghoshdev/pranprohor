import 'package:flutter/material.dart';

import '../../core/app_constants.dart';
import '../auth/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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

              // Profile card
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
                          color: Colors.white.withValues(alpha: 0.7),
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
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PranProhor User',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Mobile number will appear here',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
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

              // Personal information
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
                subtitle: 'Manage your name and basic information',
                color: AppConstants.primaryColor,
                onTap: () {},
              ),

              const SizedBox(height: 10),

              _ProfileOption(
                icon: Icons.phone_outlined,
                title: 'Mobile Number',
                subtitle: 'Your verified phone number',
                color: AppConstants.blueColor,
                onTap: () {},
              ),

              const SizedBox(height: 10),

              _ProfileOption(
                icon: Icons.location_on_outlined,
                title: 'Saved Location',
                subtitle: 'Manage your preferred location',
                color: AppConstants.orangeColor,
                onTap: () {},
              ),

              const SizedBox(height: 28),

              // Emergency
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
                subtitle: 'People to contact during an emergency',
                color: AppConstants.emergencyColor,
                onTap: () {},
              ),

              const SizedBox(height: 10),

              _ProfileOption(
                icon: Icons.medical_information_outlined,
                title: 'Medical Information',
                subtitle: 'Important information for emergency care',
                color: AppConstants.emergencyColor,
                onTap: () {},
              ),

              const SizedBox(height: 28),

              // Account
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
                subtitle: 'Manage emergency and app notifications',
                color: AppConstants.primaryColor,
                onTap: () {},
              ),

              const SizedBox(height: 10),

              _ProfileOption(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy & Security',
                subtitle: 'Manage your account privacy',
                color: AppConstants.blueColor,
                onTap: () {},
              ),

              const SizedBox(height: 10),

              _ProfileOption(
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
                subtitle: 'Get help with PranProhor',
                color: AppConstants.orangeColor,
                onTap: () {},
              ),

              const SizedBox(height: 24),

              // Logout
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await AuthService.signOut();
                  },
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
                    foregroundColor: AppConstants.emergencyColor,
                    side: BorderSide(
                      color: AppConstants.emergencyColor.withValues(
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
                crossAxisAlignment: CrossAxisAlignment.start,
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