import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/app_constants.dart';
import '../location/location_gate.dart';
import 'profile_service.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String? _selectedGender;
  String? _selectedBloodGroup;

  bool _isSaving = false;

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  final List<String> _bloodGroupOptions = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final age = int.parse(_ageController.text.trim());

      await ProfileService.saveProfile(
        uid: user.uid,
        name: _nameController.text.trim(),
        age: age,
        gender: _selectedGender,
        bloodGroup: _selectedBloodGroup,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const LocationGate(),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to save profile. Please try again.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top branding
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
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
                            'Profile Setup',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              color: AppConstants.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Welcome section
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
                          alpha: 0.18,
                        ),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                      SizedBox(height: 14),
                      Text(
                        'Welcome to PranProhor',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        'Tell us a few basic details so we can personalize your emergency care experience.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Basic Information',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: AppConstants.textDark,
                  ),
                ),

                const SizedBox(height: 7),

                const Text(
                  'These details can be updated later from your profile.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConstants.textLight,
                  ),
                ),

                const SizedBox(height: 18),

                // Full name
                _FieldLabel(
                  icon: Icons.person_outline_rounded,
                  label: 'Full Name',
                  requiredField: true,
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Enter your full name',
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: AppConstants.textLight,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }

                    if (value.trim().length < 2) {
                      return 'Please enter a valid name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Age
                _FieldLabel(
                  icon: Icons.cake_outlined,
                  label: 'Age',
                  requiredField: true,
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Enter your age',
                    prefixIcon: Icon(
                      Icons.cake_outlined,
                      color: AppConstants.textLight,
                    ),
                    suffixText: 'years',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your age';
                    }

                    final age = int.tryParse(value.trim());

                    if (age == null || age < 1 || age > 120) {
                      return 'Please enter an age between 1 and 120';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Gender
                _FieldLabel(
                  icon: Icons.wc_outlined,
                  label: 'Gender',
                  requiredField: false,
                ),

                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  initialValue: _selectedGender,
                  decoration: const InputDecoration(
                    hintText: 'Select gender',
                    prefixIcon: Icon(
                      Icons.wc_outlined,
                      color: AppConstants.textLight,
                    ),
                  ),
                  items: _genderOptions.map((gender) {
                    return DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: _isSaving
                      ? null
                      : (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // Blood group
                _FieldLabel(
                  icon: Icons.bloodtype_outlined,
                  label: 'Blood Group',
                  requiredField: false,
                ),

                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  initialValue: _selectedBloodGroup,
                  decoration: const InputDecoration(
                    hintText: 'Select blood group',
                    prefixIcon: Icon(
                      Icons.bloodtype_outlined,
                      color: AppConstants.emergencyColor,
                    ),
                  ),
                  items: _bloodGroupOptions.map((bloodGroup) {
                    return DropdownMenuItem<String>(
                      value: bloodGroup,
                      child: Text(bloodGroup),
                    );
                  }).toList(),
                  onChanged: _isSaving
                      ? null
                      : (value) {
                    setState(() {
                      _selectedBloodGroup = value;
                    });
                  },
                ),

                const SizedBox(height: 28),

                // Emergency information note
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppConstants.emergencyLight,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppConstants.emergencyColor.withValues(
                        alpha: 0.12,
                      ),
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppConstants.emergencyColor,
                        size: 22,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your blood group can be useful during an emergency. If you are unsure, you can leave it blank and add it later.',
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.45,
                            color: AppConstants.textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Continue button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _continue,
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
                      Icons.arrow_forward_rounded,
                      size: 21,
                    ),
                    label: Text(
                      _isSaving ? 'Saving...' : 'Continue',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: Text(
                    'জীবনের পাশে, প্রতিটি প্রহরে',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.primaryDark.withValues(
                        alpha: 0.75,
                      ),
                    ),
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

class _FieldLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool requiredField;

  const _FieldLabel({
    required this.icon,
    required this.label,
    required this.requiredField,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: AppConstants.primaryColor,
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppConstants.textDark,
          ),
        ),
        if (requiredField)
          const Text(
            ' *',
            style: TextStyle(
              color: AppConstants.emergencyColor,
              fontWeight: FontWeight.w800,
            ),
          ),
      ],
    );
  }
}