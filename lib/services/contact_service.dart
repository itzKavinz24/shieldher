import '../database/database_helper.dart';
import '../models/contact_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ContactService {
  Future<int> addContact(
    ContactModel contact,
  ) async {
    final db =
        await DatabaseHelper.instance.database;

    return await db.insert(
      'contacts',
      contact.toMap(),
    );
  }

  Future<List<ContactModel>>
      getContacts() async {
    final db =
        await DatabaseHelper.instance.database;

    final uid =
        FirebaseAuth.instance.currentUser!.uid;

    final result = await db.query(
      'contacts',
      where: 'uid = ?',
      whereArgs: [uid],
    );

    return result
        .map(
          (e) =>
              ContactModel.fromMap(e),
        )
        .toList();
  }

  Future<int> deleteContact(
    int id,
  ) async {
    final db =
        await DatabaseHelper.instance.database;

    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<void> clearContacts() async {
  final db =
      await DatabaseHelper.instance.database;

  await db.delete('contacts');
    }
    Future<void> insertSyncedContact(
  ContactModel contact,
) async {
  final db =
      await DatabaseHelper.instance.database;

  await db.insert(
    'contacts',
    contact.toMap(),
  );
}
}