import 'package:osyter_app/data/database.dart';
import 'package:osyter_app/model/Feed.dart';

class Repository {
  static final Repository _repo = new Repository._internal();

  AppDatabase database;

  static Repository get() {
    return _repo;
  }

  Repository._internal() {
    database = AppDatabase.get();
  }

  Future<List<Feed>> getFeeds() {}
}
