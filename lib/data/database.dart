import 'dart:async';
import 'dart:io';

import 'package:oyster/model/User.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase _bookDatabase = new AppDatabase._internal();

  Database db;
  bool didInit = false;

  AppDatabase._internal();

  static AppDatabase get() {
    return _bookDatabase;
  }

  Future<Database> _getDb() async {
    if (!didInit) await _init();
    return db;
  }

  Future _init() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "app.db");
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      print("db version: ${version}.");
      await db
          .execute("CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT)");

      await db
          .execute("CREATE TABLE Token(id INTEGER PRIMARY KEY, token TEXT)");
      print("Created tables");
    });
    didInit = true;
  }

  Future clear() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "app.db");
    await deleteDatabase(path);
  }

  Future<bool> isLoggedIn() async {
    var db = await _getDb();
    var res = await db.query("User");
    return res.length > 0 ? true : false;
  }

  Future<int> saveUser(User user) async {
    print("save user ${user.toMap()}");
    var db = await _getDb();
    int res = await db.insert("User", user.toMap());
    return res;
  }

  Future<void> clearUser() async {
    var db = await _getDb();
    await db.execute("DELETE FROM User");
  }

  Future<int> saveAuthToken(String token) async {
    var db = await _getDb();
    var res = await db.insert("Token", {"token": token});
    return res;
  }

  Future<void> clearAuthToken() async {
    var db = await _getDb();
    await db.execute("DELETE FROM Token");
  }

  Future<String> getAuthToken() async {
    var db = await _getDb();
    var res = await db.query("Token");
    return res.first["token"];
  }
}
