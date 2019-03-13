import 'package:flutter/material.dart';
import 'package:osyter_app/app.dart';
import 'package:osyter_app/app_config.dart';

void main() {
  var configuredApp = new AppConfig(
    appName: 'Build flavors',
    flavorName: 'production',
    apiBaseUrl: 'https://api.example.com/',
    child: new MyApp(),
  );

  runApp(configuredApp);
}
