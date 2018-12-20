import 'package:osyter_app/utils/network_util.dart';
import 'package:osyter_app/model/Feed.dart';


final SERVER_HOST = "http://192.168.50.77:7788";

class RestDataSource implements AuthStateListener {
  NetworkUtil _netUtil = new NetworkUtil();

  static final BASE_URL = "http://192.168.50.77:7788";
  static final LOGIN_URL = BASE_URL + "/api/login";

  Future<ApiResult> login(String username, String password) {
    return _netUtil
        .post(LOGIN_URL, body: {"username": username, "password": password});
  }

  Future<List<Feed>> getFeeds(int limit, int offset) {
    return _netUtil
        .getByAuth("${SERVER_HOST}/api/atoms/${limit}?offset=${offset}");
  }

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN) {
      // Navigator.of(context).pushReplacementNamed(AtomsPage.tag);
    }
  }
}
