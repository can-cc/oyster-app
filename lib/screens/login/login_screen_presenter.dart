import 'package:oyster/auth.dart';
import 'package:oyster/data/database.dart';
import 'package:oyster/data/rest_ds.dart';
import 'package:oyster/model/User.dart';
import 'package:oyster/utils/http_client.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(User user);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDataSource api = new RestDataSource();
  LoginScreenPresenter(this._view);

  doLogin(String username, String password) async {
    try {
      final ApiResult result = await api.login(username, password);
      final User user = new User.map(result.body);
      var db = AppDatabase.get();
      await db.saveUser(user);

      var authStateProvider = new AuthStateProvider();
      authStateProvider.notify(AuthState.LOGGED_IN);
      authStateProvider.setAuthToken(result.header["authorization"]);
    } on Exception catch (error) {
      _view.onLoginError(error.toString());
    }
  }
}
