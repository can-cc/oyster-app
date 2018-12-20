import 'package:osyter_app/utils/network_util.dart';
import 'package:osyter_app/model/User.dart';
import 'package:osyter_app/model/Feed.dart';
import 'package:osyter_app/auth.dart';

class RestDataSource implements AuthStateListener {
  NetworkUtil _netUtil = new NetworkUtil();

  static final BASE_URL = "http://192.168.50.77:7788";
  static final LOGIN_URL = BASE_URL + "/api/login";
  final _authStateProvider = new AuthStateProvider();

  RestDataSource() {}

  Future<User> login(String username, String password) {
    return _netUtil.post(LOGIN_URL,
        body: {"username": username, "password": password}).then((dynamic result) {
         print(result);
      return new User.map(result["body"]);
    });
  }

  Future<List<Feed>> getFeeds() {
//    return _netUtil.getByAuth("http://192.168.50.77:7788/api/atoms/30?offset=0", _authStateProvider)
  }

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN) {
      // Navigator.of(context).pushReplacementNamed(AtomsPage.tag);
    }
  }
}
