import 'package:osyter_app/data/rest_ds.dart';
import 'package:osyter_app/model/Feeds.dart';

abstract class FeedsScreenContract {
  void onFeedReceived(Feeds newFeeds);
  void onQueryFeedError(String errorTxt);
}

class FeedsScreenPresenter {
  FeedsScreenContract _view;
  RestDataSource api = new RestDataSource();
  FeedsScreenPresenter(this._view);

  Future<Feeds> getHeadFeeds(int limit) async {
    return await api.getFeeds(limit, 0);
  }

  queryMoreFeeds(int limit, int offset) async {
    try {
      final Feeds feeds = await api.getFeeds(limit, offset);
      _view.onFeedReceived(feeds);
    } on Exception catch (error) {
      _view.onQueryFeedError(error.toString());
    }
  }
}
