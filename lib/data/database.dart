import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class BookDatabase {
  static final BookDatabase _bookDatabase = new BookDatabase._internal();

  BookDatabase._internal();

  static BookDatabase get() {
    return _bookDatabase;
  }
}