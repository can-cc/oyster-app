import 'package:flutter/material.dart';
import 'package:oyster/app.dart';
import 'package:oyster/data/rest_ds.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  RestDataSource api = new RestDataSource();
  // api.setServerEndPoint("http://192.168.50.8:7788/api");
  api.setServerEndPoint("https://oyster.chencanhao.com/api");

  runApp(new MyApp());
}

