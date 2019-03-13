import 'package:flutter/material.dart';
import 'package:osyter_app/auth.dart';
import 'package:osyter_app/screens/feeds/feeds_screen.dart';

import './screens/login-screen.dart';

class MyApp extends StatelessWidget implements AuthStateListener {
  // This widget is the root of your application.
  BuildContext context;

  final routes = <String, WidgetBuilder>{
    FeedsPage.tag: (context) => FeedsPage(),
    LoginPage.tag: (context) => LoginPage()
  };

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN) {
      Navigator.of(context).pushReplacementNamed(FeedsPage.tag);
    }
  }

  @override
  Widget build(BuildContext context) {
    context = context;
    return MaterialApp(
      title: 'Oyster',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF5D68FF),
        fontFamily: 'Nunito',
      ),
      home: LoginPage(),
      routes: routes,
    );
  }
}
