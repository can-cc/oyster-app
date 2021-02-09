import 'package:flutter/material.dart';
import 'package:oyster/screens/feeds/feeds_screen.dart';
import 'package:oyster/screens/login/login_screen.dart';
import 'package:oyster/screens/splash/splash_screen.dart';

class MyApp extends StatelessWidget {
  BuildContext context;

  final routes = <String, WidgetBuilder>{
    FeedsPage.tag: (context) => FeedsPage(),
    LoginScreen.tag: (context) => LoginScreen()
  };

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
      home: SplashScreen(),
      routes: routes,
    );
  }
}
