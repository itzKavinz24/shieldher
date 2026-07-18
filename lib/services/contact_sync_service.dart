import 'package:firebase_auth/firebase_auth.dart';

import '../models/contact_model.dart';
import 'contact_firestore_service.dart';
import 'contact_service.dart';

class ContactSyncService {
  Future<void> syncContacts() async {
    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final cloudContacts =
        await ContactFirestoreService()
            .getContacts(user.uid);

    final localService =
        ContactService();

    await localService.clearContacts();

    for (final contact
        in cloudContacts) {
      await localService
          .insertSyncedContact(
        ContactModel(
          uid: user.uid,
          name: contact['name'],
          phone: contact['phone'],
          relationship:
              contact['relationship'],
        ),
      );
    }
  }
}