import 'package:cloud_firestore/cloud_firestore.dart';

class ContactFirestoreService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> addContact({
    required String uid,
    required String name,
    required String phone,
    required String relationship,
  }) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('contacts')
        .add({
      'name': name,
      'phone': phone,
      'relationship': relationship,
      'createdAt':
          FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>>
      getContacts(String uid) async {
    final snapshot =
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('contacts')
            .get();

    return snapshot.docs
        .map((doc) => doc.data())
        .toList();
  }

  Future<void> deleteContact({
    required String uid,
    required String phone,
  }) async {

    final contacts =
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('contacts')
            .where(
              'phone',
              isEqualTo: phone,
            )
            .get();

    for (final doc in contacts.docs) {
      await doc.reference.delete();
    }
  }

}