import 'package:flutter/material.dart';
import 'package:oyster/screens/feeds/feeds_screen.dart';
import 'package:oyster/screens/login/login-screen.dart';

import '../../auth.dart';

class SplashScreen extends StatefulWidget {
  static String tag = 'setting-screen';
  SplashScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> implements AuthStateListener {

  SplashScreenState() {
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN) {
      Navigator.of(context).pushReplacementNamed(FeedsPage.tag);
    } else if (state == AuthState.LOGGED_OUT) {
      Navigator.of(context).pushReplacementNamed(LoginPage.tag);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: new Container(
              width: 230,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/logo.png"),
                  fit: BoxFit.contain,
                ),
              ))),
    );
  }
}
