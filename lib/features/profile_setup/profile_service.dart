import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  ProfileService._();

  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  static Future<bool> profileExists(String uid) async {
    final document = await _users.doc(uid).get();
    return document.exists;
  }

  static Future<void> saveProfile({
    required String uid,
    required String name,
    required int age,
    String? gender,
    String? bloodGroup,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    await _users.doc(uid).set({
      'uid': uid,
      'phoneNumber': user?.phoneNumber,
      'name': name.trim(),
      'age': age,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}