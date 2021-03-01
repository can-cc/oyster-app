import 'package:oyster/data/database.dart';

enum AuthState { LOGGED_IN, LOGGED_OUT }

abstract class AuthStateListener {
  void onAuthStateChanged(AuthState state);
}

// A native implementation of Observer/Subscriber Pattern.
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
    print("initState");
    try {
      var isLoggedIn = await db.isLoggedIn();
      if (isLoggedIn) {
        authToken = await db.getAuthToken();
        setAuthToken(authToken);
        notify(AuthState.LOGGED_IN);
        print("auth get token");
      } else {
        print("Login fail");
        notify(AuthState.LOGGED_OUT);
      }
    } catch (error) {
      db.clear();
    }
  }

  void subscribe(AuthStateListener listener) {
    _subscribers.add(listener);
  }

  void dispose(AuthStateListener listener) {
    _subscribers.removeWhere((l) => l == listener);
  }

  void notify(AuthState state) {
    _subscribers.forEach((AuthStateListener s) => s.onAuthStateChanged(state));
  }

  void setAuthToken(String token) {
    authToken = token;
  }

  String getAuthToken() {
    return authToken;
  }

  void logout() async {
    notify(AuthState.LOGGED_OUT);
    var db = AppDatabase.get();
    await db.clearAuthToken();
    await db.clearUser();
  }
}
