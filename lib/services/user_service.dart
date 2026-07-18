import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUser(
    String uid,
  ) async {
    final doc = await _firestore
        .collection('users')
        .doc(uid)
        .get();

    return doc.data();
  }

  Future<void> updateUser({
  required String uid,
  required String name,
  required String phone,
}) async {
  await _firestore
      .collection('users')
      .doc(uid)
      .update({
    'name': name,
    'phone': phone,
    'updatedAt':
        FieldValue.serverTimestamp(),
  });
}}