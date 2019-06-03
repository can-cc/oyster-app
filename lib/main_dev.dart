import 'package:flutter/material.dart';
import 'package:oyster/app.dart';
import 'package:oyster/app_config.dart';
import 'package:oyster/data/rest_ds.dart';

void main() {
  RestDataSource api = new RestDataSource();
  api.setServerEndPoint("http://192.168.50.173:7788");

  var configuredApp = new AppConfig(
    appName: 'Oyster',
    apiBaseUrl: 'http://192.168.50.77:7788',
    child: new MyApp(),
  );

  runApp(configuredApp);
}
