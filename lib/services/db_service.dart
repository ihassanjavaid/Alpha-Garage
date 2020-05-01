import 'package:alphagarage/models/message_model.dart';
import 'package:alphagarage/models/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService {
  Future<Database> _database;

  DBService() {
    openDB();
  }

  openDB() async {
    // Open the database and store the reference.
    _database = openDatabase(
      // Set the path to the database.
      join(await getDatabasesPath(), 'chats_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, email TEXT)",
        );
        return db.execute(
          "CREATE TABLE chats(id INTEGER PRIMARY KEY, message TEXT, timestamp TEXT, user_id INTEGER FOREIGN KEY)",
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  insert<T>(T data) async {}
}
