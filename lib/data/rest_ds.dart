import 'package:osyter_app/utils/network_util.dart';
import 'package:osyter_app/model/User.dart';

class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://192.168.50.77:7788";
  static final LOGIN_URL = BASE_URL + "/api/login";

  Future<User> login(String username, String password) {
    print("${username}, ${password}");
    return _netUtil.post(LOGIN_URL, body: {
      "username": username,
      "password": password
    }).then((dynamic res) {
      print(res.toString());
      return new User.map(res);
    });
  }
}