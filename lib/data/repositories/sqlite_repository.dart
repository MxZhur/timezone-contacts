import 'dart:async';

import './repository.dart';
import '../sqlite/database.dart';
import '../models/models.dart';

class SqliteRepository extends Repository {
  final dbHelper = DatabaseHelper.instance;

  @override
  Future<List<Contact>> findAllContacts() {
    return dbHelper.findAllContacts();
  }

  @override
  Stream<List<Contact>> watchAllContacts() {
    return dbHelper.watchAllContacts();
  }

  @override
  Future<Contact> findContactById(int id) {
    return dbHelper.findContactById(id);
  }

  @override
  Future<int> addContact(Contact contact) async {
    final id = await dbHelper.addContact(contact);
    contact.id = id;
    return id;
  }

  @override
  Future<void> updateContact(Contact contact) {
    dbHelper.updateContact(contact);
    return Future.value();
  }

  @override
  Future<void> deleteContact(Contact contact) {
    dbHelper.deleteContact(contact);
    return Future.value();
  }

  @override
  Future init() async {
    await dbHelper.database;
    return Future.value();
  }

  @override
  void close() {
    dbHelper.close();
  }

}
