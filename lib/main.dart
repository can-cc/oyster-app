import 'package:flutter/material.dart';
import 'package:osyter_app/app.dart';
import 'package:osyter_app/app_config.dart';
import 'package:osyter_app/data/rest_ds.dart';

void main() {
  RestDataSource api = new RestDataSource();
  api.setServerEndPoint("https://feed.octopuese.xyz");

  var configuredApp = new AppConfig(
    appName: 'Oyster',
    apiBaseUrl: 'https://feed.octopuese.xyz', // 暂时没用
    child: new MyApp(),
  );

  runApp(configuredApp);
}
