import 'package:osyter_app/model/User.dart';
import 'package:osyter_app/data/rest_ds.dart';
import 'package:osyter_app/data/database.dart';
import 'package:osyter_app/auth.dart';

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
      var user = await api.login(username, password);
      var db = AppDatabase.get();
      await db.saveUser(user);
      var authStateProvider = new AuthStateProvider();
      authStateProvider.notify(AuthState.LOGGED_IN);
    } on Exception catch (error) {
      _view.onLoginError(error.toString());
    }
  }
}
