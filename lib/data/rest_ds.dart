import 'package:oyster/model/FeedMark.dart';
import 'package:oyster/model/FeedSource.dart';
import 'package:oyster/model/Feeds.dart';
import 'package:oyster/utils/http_client.dart';

class RestDataSource {
  String SERVER_HOST;

  HttpClient _netUtil = new HttpClient();

  static RestDataSource _instance = new RestDataSource.internal();
  RestDataSource.internal();
  factory RestDataSource() => _instance;

//  static final LOGIN_URL = SERVER_HOST + "/api/login";

  void setServerEndPoint(String endpoint) {
    SERVER_HOST = endpoint;
  }

  Future<ApiResult> login(String username, String password) {
    return _netUtil.postByAuth(SERVER_HOST + "/login",
        body: {"username": username, "password": password});
  }

  Future<Feeds> getFeeds(int limit, int offset, String category) {
    String categoryQuery = '';
    if (category != null) {
      categoryQuery = "&category=${category}";
    }
    return _netUtil
        .getByAuth("${SERVER_HOST}/feeds/${limit}?offset=${offset}${categoryQuery}")
        .then((dynamic feeds) {
      return Feeds.fromJson(feeds);
    });
  }

  Future<FeedMark> markFeedFavorite(String feedId) async {
    final ApiResult result = await _netUtil
        .postByAuth("${SERVER_HOST}/feed/${feedId}/favorite", body: {});
    return FeedMark.map(result.body);
  }

  Future<void> removeFeedFavoriteMark(String feedId, String markId) async {
    await _netUtil
        .deleteByAuth("${SERVER_HOST}/feed/${feedId}/favorite/${markId}");
  }

  Future<List<FeedSource>> getFeedSources() {
    return _netUtil
        .getByAuth("${SERVER_HOST}/feed-sources")
        .then((dynamic feedSources) {
      return feedSources
          .map<FeedSource>((source) => FeedSource.map(source))
          .toList();
    });
  }
}
