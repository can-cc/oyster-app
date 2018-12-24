import 'package:osyter_app/data/rest_ds.dart';
import 'package:osyter_app/model/Feed.dart';

abstract class FeedsScreenContract {
  void onFeedReceived(List<Feed> newFeeds);
  void onQueryFeedError(String errorTxt);
}

class FeedsScreenPresenter {
  FeedsScreenContract _view;
  RestDataSource api = new RestDataSource();
  FeedsScreenPresenter(this._view);

  queryFeeds(int limit, int offset) async {
    try {
      final List<Feed> feeds = await api.getFeeds(limit, offset);
      _view.onFeedReceived(feeds);
    } on Exception catch (error) {
      _view.onQueryFeedError(error.toString());
    }
  }
}
