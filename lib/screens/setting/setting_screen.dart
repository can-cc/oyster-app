import 'dart:async';
import 'package:flutter/material.dart';
import 'package:oyster/screens/login/login-screen.dart';

import '../../auth.dart';

class SettingScreen extends StatefulWidget {
  static String tag = 'setting-screen';
  SettingScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  SettingScreenState createState() => new SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  final _authStateProvider = new AuthStateProvider();

  SettingScreenState() {}

  _logout() {
    Navigator.of(context).pushReplacementNamed(LoginPage.tag);
    _authStateProvider.logout();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Text("Setting", style: TextStyle(color: Colors.white))),
        body: ListView(
          children: <Widget>[
            RaisedButton(
              onPressed: _logout,
              child: Text('Logout', style: TextStyle(fontSize: 20)),
            ),
          ],
        ));
  }
}
