  import 'package:cloud_firestore/cloud_firestore.dart';

  class FirestoreService {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    Future<void> saveUser({
      required String uid,
      required String name,
      required String email,
      required String phone,
      required String role,
    }) async {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'parentId': '',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    // ADD THIS METHOD
    Future<Map<String, dynamic>> getUser(String uid) async {
      final doc = await _firestore.collection('users').doc(uid).get();

      return doc.data()!;
    }
  }
