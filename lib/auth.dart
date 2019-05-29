import 'package:oyster/data/database.dart';

enum AuthState { LOGGED_IN, LOGGED_OUT }

abstract class AuthStateListener {
  void onAuthStateChanged(AuthState state);
}

// A naive implementation of Observer/Subscriber Pattern. Will do for now.
class AuthStateProvider {
  static final AuthStateProvider _instance = new AuthStateProvider.internal();
  String authToken;

  List<AuthStateListener> _subscribers;

  factory AuthStateProvider() => _instance;
  AuthStateProvider.internal() {
    _subscribers = new List<AuthStateListener>();
    initState();
  }

  void initState() async {
    var db = AppDatabase.get();
    var isLoggedIn = await db.isLoggedIn();
    if (isLoggedIn) {
      authToken = await db.getAuthToken();
      notify(AuthState.LOGGED_IN);
      print("auth get token");
    } else {
      print("Login fail");
      notify(AuthState.LOGGED_OUT);
    }
  }

  void subscribe(AuthStateListener listener) {
    _subscribers.add(listener);
  }

  void dispose(AuthStateListener listener) {
    for (var l in _subscribers) {
      if (l == listener) _subscribers.remove(l);
    }
  }

  void notify(AuthState state) {
    _subscribers.forEach((AuthStateListener s) => s.onAuthStateChanged(state));
  }

  void setAuthToken(String token) async {
    var db = AppDatabase.get();
    authToken = token;
    await db.saveAuthToken(token);
  }

  String getAuthToken() {
    return authToken;
  }

  void logout() async {
    print("logout func");
    notify(AuthState.LOGGED_OUT);

    var db = AppDatabase.get();
    await db.clearAuthToken();
    await db.clearUser();
  }
}
