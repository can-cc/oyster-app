import 'package:flutter/material.dart';
import 'package:oyster/app.dart';
import 'package:oyster/app_config.dart';
import 'package:oyster/data/rest_ds.dart';

void main() {
  RestDataSource api = new RestDataSource();
  api.setServerEndPoint("https://feed.octopuese.xyz");

  var configuredApp = new AppConfig(
    appName: 'Oyster',
    apiBaseUrl: 'https://feed.octopuese.xyz',
    child: new MyApp(),
  );

  runApp(configuredApp);
}
