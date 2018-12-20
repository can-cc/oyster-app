import 'package:osyter_app/model/User.dart';
import 'package:osyter_app/data/rest_ds.dart';
import 'package:osyter_app/data/database.dart';
import 'package:osyter_app/auth.dart';
import 'package:osyter_app/utils/network_util.dart';

abstract class LoginScreenContract {
  void onLoginSuccess(User user);
  void onLoginError(String errorTxt);
}

class LoginScreenPresenter {
  LoginScreenContract _view;
  RestDatasource api = new RestDatasource();
  LoginScreenPresenter(this._view);

  doLogin(String username, String password) async {
    try {
      final ApiResult result = await api.login(username, password);
      final User user = new User.map(result.body);
      var db = AppDatabase.get();
      await db.saveUser(user);

      var authStateProvider = new AuthStateProvider();
      authStateProvider.notify(AuthState.LOGGED_IN);
      authStateProvider.setAuthToken(result.header["Authorization"]);
    } on Exception catch (error) {
      _view.onLoginError(error.toString());
    }
  }
}
