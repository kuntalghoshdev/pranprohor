import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/app_constants.dart';
import 'auth_service.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    FocusScope.of(context).unfocus();

    final phone = _phoneController.text.trim();

    if (phone.length < 10) {
      setState(() {
        _errorMessage = 'Please enter a valid phone number.';
      });
      return;
    }

    final fullPhoneNumber = '+91$phone';

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await AuthService.sendOtp(
        phoneNumber: fullPhoneNumber,

        codeSent: (verificationId, forceResendingToken) {
          if (!mounted) return;

          setState(() {
            _isLoading = false;
          });

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => OtpScreen(
                phoneNumber: fullPhoneNumber,
                verificationId: verificationId,
              ),
            ),
          );
        },

        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await FirebaseAuth.instance.signInWithCredential(credential);

            if (!mounted) return;

            setState(() {
              _isLoading = false;
            });
          } catch (e) {
            if (!mounted) return;

            setState(() {
              _isLoading = false;
              _errorMessage = 'Automatic verification failed.';
            });
          }
        },

        verificationFailed: (FirebaseAuthException error) {
          if (!mounted) return;

          setState(() {
            _isLoading = false;
            _errorMessage = _getFirebaseErrorMessage(error);
          });
        },

        codeAutoRetrievalTimeout: (verificationId) {
          if (!mounted) return;

          setState(() {
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Something went wrong. Please try again.';
      });
    }
  }

  String _getFirebaseErrorMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-phone-number':
        return 'The phone number is invalid.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again later.';
      case 'network-request-failed':
        return 'Please check your internet connection.';
      default:
        return error.message ?? 'Phone verification failed.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              Center(
                child: Image.asset(
                  'assets/images/pranprohor_logo.png',
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                'Welcome to PranProhor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppConstants.textDark,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Enter your phone number to continue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppConstants.textLight,
                ),
              ),

              const SizedBox(height: 36),

              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  hintText: '9876543210',
                  prefixText: '+91 ',
                  counterText: '',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),

              const SizedBox(height: 12),

              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppConstants.emergencyColor.withValues(
                      alpha: 0.08,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: AppConstants.emergencyColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _sendOtp,
                child: _isLoading
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  'Send OTP',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'By continuing, you agree to use your phone number '
                    'for secure authentication.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppConstants.textLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}