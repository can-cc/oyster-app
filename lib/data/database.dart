import 'dart:async';
import 'dart:io';

import 'package:oyster/model/Feed.dart';
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
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, "app.db");
      db = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
            // When creating the db, create the table
            print("db version: ${version}.");
            await db
                .execute("CREATE TABLE IF NOT EXISTS User(id INTEGER PRIMARY KEY, username TEXT)");

            await db
                .execute("CREATE TABLE IF NOT EXISTS Token(id INTEGER PRIMARY KEY, token TEXT)");

            await db
                .execute("CREATE TABLE IF NOT EXISTS Feed(id INT(24) PRIMARY KEY, title VARCHAR(200), content TEXT, originHref TEXT, createdAt VARCHAR(20), originCreatedAt VARCHAR(20), source VARCHAR(36), isFavorite INT)");

            print("Created tables");
          });
      didInit = true;
    } catch(error) {
      print("读取数据库失败.");
      print(error);
      throw error;
    }
  }

  Future clear() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "app.db");
    print("delete database");
    await deleteDatabase(path);
  }

  Future<bool> isLoggedIn() async {
    var db = await _getDb();
    var res = await db.query("User");

    return res.length > 0 ? true : false;
  }

  Future saveFeeds(List<Feed> feeds) async {
    var db = await _getDb();
    for (Feed feed in feeds) {
      await db.insert("Feed", feed.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore );
    }
  }

  Future<List<Feed>> getFeeds(String source, int offset, int limit, int id) async {
    var db = await _getDb();
    List<Map> maps = await db.query("Feed", where: 'source = ? AND id > ?', whereArgs: [source, id], limit: limit, offset: offset, orderBy: "createdAt DESC");
    // List<Map> maps = await db.query("Feed");
    print(maps.length);
    return maps.map((e) => Feed.map(e)).toList();
  }

  Future<int> saveUser(User user) async {
    print("save user ${user.toMap()}");
    var db = await _getDb();
    int res = await db.insert("User", user.toMap());
    print("save success");
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
