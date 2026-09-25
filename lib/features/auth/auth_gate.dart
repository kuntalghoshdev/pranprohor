import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../location/location_gate.dart';
import '../profile_setup/profile_setup_screen.dart';
import 'auth_service.dart';
import 'login_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  Future<bool>? _profileFuture;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      _profileFuture = _profileExists(user);
    }
  }

  Future<bool> _profileExists(User user) async {
    final document = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    return document.exists;
  }

  void _checkProfileAgain(User user) {
    setState(() {
      _profileFuture = _profileExists(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _LoadingScreen();
        }

        final user = snapshot.data;

        // User is logged out.
        if (user == null) {
          return const LoginScreen();
        }

        // Create the Firestore check for the authenticated user.
        _profileFuture ??= _profileExists(user);

        return FutureBuilder<bool>(
          future: _profileFuture,
          builder: (context, profileSnapshot) {
            // Firestore request is still running.
            if (profileSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const _LoadingScreen();
            }

            // Firestore request failed.
            if (profileSnapshot.hasError) {
              return _ProfileErrorScreen(
                onRetry: () {
                  _checkProfileAgain(user);
                },
              );
            }

            final profileExists =
                profileSnapshot.data ?? false;

            // Existing user:
            //
            // OTP
            //   ↓
            // Location
            //   ↓
            // Home
            if (profileExists) {
              return const LocationGate();
            }

            // New user:
            //
            // OTP
            //   ↓
            // Profile Setup
            //   ↓
            // Firestore
            //   ↓
            // Location
            //   ↓
            // Home
            return const ProfileSetupScreen();
          },
        );
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _ProfileErrorScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const _ProfileErrorScreen({
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Unable to load your profile.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: onRetry,
                  child: const Text('Retry'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}