import 'package:osyter_app/model/FeedMark.dart';
import 'package:osyter_app/model/FeedSource.dart';
import 'package:osyter_app/model/Feeds.dart';
import 'package:osyter_app/utils/network_util.dart';

final SERVER_HOST = "http://192.168.50.77:7788";

class RestDataSource {
  NetworkUtil _netUtil = new NetworkUtil();

  static final LOGIN_URL = SERVER_HOST + "/api/login";

  Future<ApiResult> login(String username, String password) {
    return _netUtil.postByAuth(LOGIN_URL,
        body: {"username": username, "password": password});
  }

  Future<Feeds> getFeeds(int limit, int offset) {
    return _netUtil
        .getByAuth("${SERVER_HOST}/api/feeds/${limit}?offset=${offset}")
        .then((dynamic feeds) {
      return Feeds.fromJson(feeds);
    });
  }

  Future<FeedMark> markFeedFavorite(String feedId) async {
    final ApiResult result = await _netUtil
        .postByAuth("${SERVER_HOST}/api/feed/${feedId}/favorite", body: {});
    return FeedMark.map(result.body);
  }

  Future<List<FeedSource>> getFeedSources() {
    return _netUtil
        .getByAuth("${SERVER_HOST}/api/feed-sources")
        .then((dynamic feedSources) {
      return feedSources
          .map<FeedSource>((source) => FeedSource.map(source))
          .toList();
    });
  }
}
