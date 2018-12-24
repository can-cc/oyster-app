import 'package:osyter_app/auth.dart';
import 'package:osyter_app/model/Feeds.dart';
import 'package:osyter_app/utils/network_util.dart';

final SERVER_HOST = "http://192.168.50.77:7788";

class RestDataSource implements AuthStateListener {
  NetworkUtil _netUtil = new NetworkUtil();

  static final LOGIN_URL = SERVER_HOST + "/api/login";

  Future<ApiResult> login(String username, String password) {
    return _netUtil.postWithHeader(LOGIN_URL,
        body: {"username": username, "password": password});
  }

  Future<Feeds> getFeeds(int limit, int offset) {
    return _netUtil
        .getByAuth("${SERVER_HOST}/api/feeds/${limit}?offset=${offset}")
        .then((dynamic feeds) {return Feeds.fromJson(feeds);});
  }

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN) {
      // Navigator.of(context).pushReplacementNamed(AtomsPage.tag);
    }
  }
}
