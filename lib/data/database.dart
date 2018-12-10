import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:osyter_app/model/User.dart';

class BookDatabase {
  static final BookDatabase _bookDatabase = new BookDatabase._internal();

  Database db;
  bool didInit = false;

  BookDatabase._internal();

  static BookDatabase get() {
    return _bookDatabase;
  }

  Future<Database> _getDb() async{
    if(!didInit) await _init();
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
          await db.execute(
              "CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT)");
        });
    print("Created tables");
    didInit = true;
  }

  Future<bool> isLoggedIn() async {
    var db = await _getDb();
    var res = await db.query("User");
    return res.length > 0? true: false;
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }

}