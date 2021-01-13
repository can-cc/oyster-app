import 'package:flutter/material.dart';
import 'package:oyster/app.dart';
import 'package:oyster/data/rest_ds.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  RestDataSource api = new RestDataSource();
  api.setServerEndPoint("http://192.168.50.134:9888/api");

  runApp(new MyApp());
}