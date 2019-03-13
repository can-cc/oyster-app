import 'package:flutter/material.dart';
import 'package:osyter_app/app.dart';
import 'package:osyter_app/app_config.dart';
import 'package:osyter_app/data/rest_ds.dart';

void main() {
  RestDataSource api = new RestDataSource();
  api.setServerEndPoint("http://192.168.50.77:7788");

  var configuredApp = new AppConfig(
    appName: 'Oyster',
    apiBaseUrl: 'http://192.168.50.77:7788',
    child: new MyApp(),
  );

  runApp(configuredApp);
}
