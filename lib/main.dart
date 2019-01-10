import 'package:flutter/material.dart';
import 'package:osyter_app/screens/feed_detail/feed_detail_screen.dart';
import 'package:osyter_app/screens/feeds/feeds_screen.dart';

import './screens/login-screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final routes = <String, WidgetBuilder>{
    FeedsPage.tag: (context) => FeedsPage(),
    LoginPage.tag: (context) => LoginPage(),
    FeedDetailPage.tag: (context) => FeedDetailPage()
  };

  @override
  Widget build(BuildContext context) {
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
