import 'package:oyster/data/rest_ds.dart';
import 'package:oyster/model/Feeds.dart';

abstract class FeedsScreenContract {
  void onFeedReceived(Feeds newFeeds);
  void onQueryFeedError(String errorTxt);
}

class FeedsScreenPresenter {
  FeedsScreenContract _view;
  RestDataSource api = new RestDataSource();
  FeedsScreenPresenter(this._view);

  Future<Feeds> getHeadFeeds(int limit, String category) async {
    return await api.getFeeds(limit, 0, category);
  }

  Future<Feeds> queryLatestFeeds(int limit, String category) async {
    return await api.getFeeds(limit, 0, category);
  }

  queryMoreFeeds(int limit, int offset, String category) async {
    try {
      final Feeds feeds = await api.getFeeds(limit, offset, category);
      _view.onFeedReceived(feeds);
    } on Exception catch (error) {
      _view.onQueryFeedError(error.toString());
    }
  }
}
