import 'package:flutter/material.dart';
import 'package:oyster/app.dart';
import 'package:oyster/data/rest_ds.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  RestDataSource api = new RestDataSource();
  api.setServerEndPoint("https://feed.hayatarou.com/api");

  runApp(new MyApp());
}