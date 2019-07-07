import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:oyster/auth.dart';
import 'package:oyster/data/database.dart';
import 'package:oyster/model/User.dart';
import 'package:oyster/screens/feeds/feeds_screen.dart';
import 'package:oyster/screens/login/login-screen-presenter.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage>
    implements LoginScreenContract, AuthStateListener {
  BuildContext _ctx;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  AuthStateProvider _authStateProvider;

  bool _isLoading = false;

  String _username, _password;

  LoginScreenPresenter _presenter;

  LoginPageState() {
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
      height: 50,
    );

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 68.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final loginBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text("LOGIN"),
      color: Colors.lightBlueAccent,
    );

    final clearDbBtn = new RaisedButton(
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
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  onSaved: (val) => _username = val,
                  validator: (val) {
                    return val.length < 3
                        ? "Username must have atleast 3 chars"
                        : null;
                  },
                  decoration: new InputDecoration(labelText: "Username"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new TextFormField(
                  obscureText: true,
                  onSaved: (val) => _password = val,
                  decoration: new InputDecoration(labelText: "Password"),
                ),
              ),
            ],
          ),
        ),
        _isLoading ? new CircularProgressIndicator() : loginBtn,
        clearDbBtn
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
          children: <Widget>[topPadding, logo, loginForm, forgotLabel],
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