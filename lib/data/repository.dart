import 'package:osyter_app/data/database.dart';
import 'package:osyter_app/model/Feed.dart';
import 'package:osyter_app/model/FeedSource.dart';
import 'package:rxdart/rxdart.dart';

class Repository {
  static final Repository _repo = new Repository._internal();

  final Subject<List<FeedSource>> _sources$ = BehaviorSubject();

  AppDatabase database;

  static Repository get() {
    return _repo;
  }

  Repository._internal() {
    database = AppDatabase.get();
  }

  Future<List<Feed>> getFeeds() {}

  void refreshFeedSource() {}

  Subject<List<FeedSource>> getFeedSource$() {
    return _sources$;
  }
}
