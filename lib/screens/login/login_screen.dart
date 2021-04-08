import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:oyster/auth.dart';
import 'package:oyster/data/database.dart';
import 'package:oyster/model/User.dart';
import 'package:oyster/screens/feeds/feeds_screen.dart';
import 'package:oyster/screens/login/login_screen_presenter.dart';

class LoginScreen extends StatefulWidget {
  static String tag = 'login-page';

  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    implements LoginScreenContract, AuthStateListener {
  BuildContext _ctx;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  AuthStateProvider _authStateProvider;

  bool _isLoading = false;

  String _username, _password;
  int _textClickedTimes = 0;

  LoginScreenPresenter _presenter;

  LoginScreenState() {
    _presenter = new LoginScreenPresenter(this);
    _authStateProvider = new AuthStateProvider();
    _authStateProvider.subscribe(this);
  }

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN) {
      Navigator.of(context).pushReplacementNamed(FeedsPage.tag);
    }
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _presenter.doLogin(_username, _password);
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = SizedBox(
      height: 100,
    );

    final helloTxt = new FlatButton(
        onPressed: () {
          setState(() => _textClickedTimes++);
        },
        child: new Text("Login",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xfffdad28))));

    final loginBtn = SizedBox(
        width: double.infinity, // match_parent
        child: new FlatButton(
          onPressed: _submit,
          child: new Text("LOGIN"),
          padding: EdgeInsets.all(12.0),
          color: Colors.lightBlue,
          textColor: Colors.white,
        ));

    final clearDbBtn = new FlatButton(
      onPressed: () {
        final db = AppDatabase.get();
        db.clear();
      },
      child: new Text("Clear DB"),
      color: Colors.deepOrange,
    );

    var loginForm = new Column(
      children: <Widget>[
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(top: 20),
                child: new TextFormField(
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: TextStyle(color: Color(0xfffdad28)),
                    border: OutlineInputBorder(borderSide: BorderSide()),
                  ),
                  cursorColor: Color(0xfffdad28),
                  onSaved: (val) => _username = val,
                  validator: (val) {
                    return val.length < 3
                        ? "Username must have atleast 3 chars"
                        : null;
                  },
                ),
              ),
              new Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 30),
                child: new TextFormField(
                    strutStyle: StrutStyle.fromTextStyle(
                        TextStyle(color: Color(0xfffdad28))),
                    cursorColor: Color(0xfffdad28),
                    obscureText: true,
                    onSaved: (val) => _password = val,
                    decoration: new InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: Color(0xfffdad28)),
                        border: OutlineInputBorder(borderSide: BorderSide()))),
              ),
            ],
          ),
        ),
        loginBtn,
        _textClickedTimes >= 4
            ? clearDbBtn
            : new Padding(
                padding: const EdgeInsets.all(0),
              )
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[topPadding, helloTxt, loginForm, forgotLabel],
        ),
      ),
    );
  }

  @override
  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(User user) async {
    _showSnackBar(user.toString());
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _authStateProvider.dispose(this);
    super.dispose();
  }
}
