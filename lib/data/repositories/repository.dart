
import '../models/models.dart';

abstract class Repository {
  Future<List<Contact>> findAllContacts();

  Stream<List<Contact>> watchAllContacts();

  Future<Contact> findContactById(int id);

  Future<int> addContact(Contact contact);

  Future<void> updateContact(Contact contact);

  Future<void> deleteContact(Contact contact);

  Future init();
  void close();

}