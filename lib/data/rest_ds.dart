import 'package:oyster/model/FeedMark.dart';
import 'package:oyster/model/FeedSource.dart';
import 'package:oyster/model/Feeds.dart';
import 'package:oyster/utils/network_util.dart';

//final SERVER_HOST = "http://192.168.50.77:7788";

//var

class RestDataSource {
  String SERVER_HOST;

  NetworkUtil _netUtil = new NetworkUtil();

  static RestDataSource _instance = new RestDataSource.internal();
  RestDataSource.internal();
  factory RestDataSource() => _instance;

//  static final LOGIN_URL = SERVER_HOST + "/api/login";

  void setServerEndPoint(String endpoint) {
    SERVER_HOST = endpoint;
  }

  Future<ApiResult> login(String username, String password) {
    return _netUtil.postByAuth(SERVER_HOST + "/api/login",
        body: {"username": username, "password": password});
  }

  Future<Feeds> getFeeds(int limit, int offset, String category) {
    String categoryQuery = '';
    if (category != null) {
      categoryQuery = "&category=${category}";
    }
    return _netUtil
        .getByAuth("${SERVER_HOST}/api/feeds/${limit}?offset=${offset}${categoryQuery}")
        .then((dynamic feeds) {
      return Feeds.fromJson(feeds);
    });
  }

  Future<FeedMark> markFeedFavorite(String feedId) async {
    final ApiResult result = await _netUtil
        .postByAuth("${SERVER_HOST}/api/feed/${feedId}/favorite", body: {});
    return FeedMark.map(result.body);
  }

  Future<void> removeFeedFavoriteMark(String feedId, String markId) async {
    await _netUtil
        .deleteByAuth("${SERVER_HOST}/api/feed/${feedId}/favorite/${markId}");
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
