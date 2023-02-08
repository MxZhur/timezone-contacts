// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import '../models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlbrite/sqlbrite.dart';
// ignore: depend_on_referenced_packages
import 'package:synchronized/synchronized.dart';

class DatabaseHelper {
  static const _databaseName = 'MyContacts.db';
  static const _databaseVersion = 1;

  static const contactTable = 'Contact';

  static late BriteDatabase _streamDatabase;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static var lock = Lock();

  static Database? _database;

  Future _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE Contact ('
        'id INTEGER PRIMARY KEY,'
        'name TEXT,'
        'image TEXT NULL,'
        'timezone TEXT,'
        'utcOffset REAL'
        ')');
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(
      documentsDirectory.path,
      _databaseName,
    );

    // Sqflite.setDebugModeOn(true);

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    await lock.synchronized(() async {
      if (_database == null) {
        _database = await _initDatabase();
        _streamDatabase = BriteDatabase(_database!);
      }
    });
    return _database!;
  }

  Future<BriteDatabase> get streamDatabase async {
    await database;
    return _streamDatabase;
  }

  List<Contact> parseContacts(
    List<Map<String, dynamic>> contactList,
  ) {
    final contacts = <Contact>[];
    for (final contactMap in contactList) {
      final contact = Contact.fromJson(contactMap);
      contacts.add(contact);
    }
    return contacts;
  }

  Future<List<Contact>> findAllContacts() async {
    final db = await instance.streamDatabase;
    final contactList = await db.query(contactTable);
    final contacts = parseContacts(contactList);
    return contacts;
  }

  Stream<List<Contact>> watchAllContacts() async* {
    final db = await instance.streamDatabase;
    yield* db
        .createQuery(contactTable)
        .mapToList((row) => Contact.fromJson(row));
  }

  Future<Contact> findContactById(int id) async {
    final db = await instance.streamDatabase;
    final contactList = await db.query(
      contactTable,
      where: 'id = $id',
    );
    final contacts = parseContacts(contactList);
    return contacts.first;
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await instance.streamDatabase;
    return db.insert(
      table,
      row,
    );
  }

  Future<int> addContact(Contact contact) {
    return insert(
      contactTable,
      contact.toJson(),
    );
  }

  Future<int> update(String table, Map<String, dynamic> row, String columnId, int id) async {
    final db = await instance.streamDatabase;
    return db.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateContact(Contact contact) {
    if (contact.id != null) {
      return update(
        contactTable,
        contact.toJson(),
        'id',
        contact.id!,
      );
    } else {
      return Future.value(-1);
    }
  }

  Future<int> _delete(String table, String columnId, int id) async {
    final db = await instance.streamDatabase;
    return db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteContact(Contact contact) async {
    if (contact.id != null) {
      return _delete(
        contactTable,
        'id',
        contact.id!,
      );
    } else {
      return Future.value(-1);
    }
  }

  void close() {
    _streamDatabase.close();
  }
}
