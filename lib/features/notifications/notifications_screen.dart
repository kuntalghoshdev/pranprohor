import 'package:flutter/material.dart';

import '../../core/app_constants.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _hasUnreadNotifications = true;

  void _markAllRead() {
    setState(() {
      _hasUnreadNotifications = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
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
                          'Notifications',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppConstants.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: _hasUnreadNotifications ? _markAllRead : null,
                    child: Text(
                      _hasUnreadNotifications ? 'Mark all read' : 'All read',
                      style: TextStyle(
                        color: _hasUnreadNotifications
                            ? AppConstants.primaryColor
                            : AppConstants.textLight,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

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
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.notifications_active_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Stay informed',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Important updates about your health and emergencies will appear here.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Today',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppConstants.textDark,
                ),
              ),

              const SizedBox(height: 12),

              _NotificationCard(
                icon: Icons.local_hospital_rounded,
                iconColor: AppConstants.primaryColor,
                title: 'Hospital availability updated',
                message:
                'Nearby hospital resource information has been updated.',
                time: '10 min ago',
                unread: _hasUnreadNotifications,
              ),

              const SizedBox(height: 10),

              _NotificationCard(
                icon: Icons.bloodtype_rounded,
                iconColor: AppConstants.emergencyColor,
                title: 'Blood availability update',
                message:
                'Blood availability information is now available for nearby hospitals.',
                time: '1 hour ago',
                unread: _hasUnreadNotifications,
              ),

              const SizedBox(height: 10),

              const _NotificationCard(
                icon: Icons.location_on_rounded,
                iconColor: AppConstants.blueColor,
                title: 'Location updated',
                message:
                'Your current location was updated for nearby emergency services.',
                time: '2 hours ago',
                unread: false,
              ),

              const SizedBox(height: 28),

              const Text(
                'Earlier',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppConstants.textDark,
                ),
              ),

              const SizedBox(height: 12),

              const _NotificationCard(
                icon: Icons.favorite_rounded,
                iconColor: AppConstants.orangeColor,
                title: 'Welcome to PranProhor',
                message:
                'We are here to stay by your side whenever you need emergency assistance.',
                time: 'Yesterday',
                unread: false,
              ),

              const SizedBox(height: 10),

              const _NotificationCard(
                icon: Icons.shield_outlined,
                iconColor: AppConstants.primaryColor,
                title: 'Emergency profile reminder',
                message:
                'Complete your emergency contacts and medical information for faster assistance.',
                time: '2 days ago',
                unread: false,
              ),

              const SizedBox(height: 28),

              const Text(
                'What you may receive',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppConstants.textDark,
                ),
              ),

              const SizedBox(height: 12),

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
                child: const Column(
                  children: [
                    _NotificationTypeRow(
                      icon: Icons.local_hospital_outlined,
                      title: 'Hospital updates',
                    ),
                    SizedBox(height: 14),
                    _NotificationTypeRow(
                      icon: Icons.airport_shuttle_outlined,
                      title: 'Ambulance status',
                    ),
                    SizedBox(height: 14),
                    _NotificationTypeRow(
                      icon: Icons.bloodtype_outlined,
                      title: 'Blood availability',
                    ),
                    SizedBox(height: 14),
                    _NotificationTypeRow(
                      icon: Icons.warning_amber_rounded,
                      title: 'Emergency alerts',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

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

class _NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String time;
  final bool unread;

  const _NotificationCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.time,
    required this.unread,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: unread ? AppConstants.softTeal : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: unread
              ? AppConstants.primaryColor.withValues(alpha: 0.18)
              : AppConstants.borderColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 23,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppConstants.textDark,
                        ),
                      ),
                    ),
                    if (unread)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(
                          left: 8,
                          top: 5,
                        ),
                        decoration: const BoxDecoration(
                          color: AppConstants.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: AppConstants.textLight,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.textLight,
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

class _NotificationTypeRow extends StatelessWidget {
  final IconData icon;
  final String title;

  const _NotificationTypeRow({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppConstants.lightAqua,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(
            icon,
            color: AppConstants.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppConstants.textDark,
            ),
          ),
        ),
        const Icon(
          Icons.check_circle_outline_rounded,
          color: AppConstants.successColor,
          size: 19,
        ),
      ],
    );
  }
}