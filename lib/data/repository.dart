import 'package:oyster/data/database.dart';
import 'package:oyster/data/rest_ds.dart';
import 'package:oyster/model/Feed.dart';
import 'package:oyster/model/FeedSource.dart';
import 'package:rxdart/rxdart.dart';

class Repository {
  static final Repository _repo = new Repository._internal();

  RestDataSource api = new RestDataSource();

  final Subject<List<FeedSource>> _sources$ =
      BehaviorSubject(seedValue: List());

  // final Subject<List<Feed>> _feeds$ = BehaviorSubject(seedValue: List());
  // final Subject<List<String>> _feedIds$ = BehaviorSubject(seedValue: List());
  // final Subject<dynamic> _feedUpdate$ = BehaviorSubject();

  AppDatabase database;

  static Repository get() {
    return _repo;
  }

  Repository._internal() {
    database = AppDatabase.get();
  }

  Future<List<Feed>> getFeeds() {}

  void refreshFeedSource() async {
    List<FeedSource> feedSources = await api.getFeedSources();
    _sources$.add(feedSources);
  }

  Subject<List<FeedSource>> getFeedSource$() {
    return _sources$;
  }
}
