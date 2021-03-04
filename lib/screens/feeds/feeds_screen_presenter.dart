import 'package:oyster/data/database.dart';
import 'package:oyster/data/rest_ds.dart';
import 'package:oyster/model/Feed.dart';
import 'package:oyster/model/Feeds.dart';

abstract class FeedsScreenContract {
  void onFeedReceived(List<Feed> newFeeds);
  void onQueryFeedError(String errorTxt);
}

class FeedsScreenPresenter {
  FeedsScreenContract _view;
  RestDataSource api = new RestDataSource();
  FeedsScreenPresenter(this._view);

  Future<List<Feed>> getHeadFeeds(int limit, String category) async {
    return await queryFeeds(limit, 0, category, 0);
  }

  Future<Feeds> queryLatestFeeds(String category, int fromId) async {
    return await api.getFeeds(0, 0, category, fromId, true);
  }

  queryMoreFeeds(int limit, int offset, String category, int fromId) async {
    try {
      List<Feed> feeds = await queryFeeds(limit, 0, category, fromId);
      _view.onFeedReceived(feeds);
    } on Exception catch (error) {
      _view.onQueryFeedError(error.toString());
    }
  }

  Future<List<Feed>> queryFeeds(int limit, int offset, String category, int fromId) async {
    List<Feed> dbFeeds = await queryFeedsInDB(limit, offset, category, fromId);
    print("dbFeeds $dbFeeds");
    if (dbFeeds.length > 0) {
      return dbFeeds;
    } else {
      final Feeds feeds = await api.getFeeds(limit, offset, category, fromId, false);
      final db = AppDatabase.get();
      db.saveFeeds(feeds.items);
      return feeds.items;
    }
  }

  Future<List<Feed>> queryFeedsInDB(int limit, int offset, String category, int fromId) async {
    final db = AppDatabase.get();
    List<Feed> feeds = await db.getFeeds(category, offset, limit, 0);
    return feeds;
  }

}
