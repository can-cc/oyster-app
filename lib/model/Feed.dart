import 'dart:ffi';

import 'package:intl/intl.dart';
import 'package:oyster/data/rest_ds.dart';
import 'package:oyster/model/FeedMark.dart';
import 'package:oyster/model/FeedSource.dart';

class Feed {
  int _id;
  String _title;
  String _originHref;
  String _content;
  DateTime _createdAt;
  String _originCreatedAt;
  FeedSource _source;
  bool _isFavorite;

  RestDataSource api = new RestDataSource();

  Feed.map(dynamic obj) {
    this._id = obj["id"].toInt();
    this._title = obj["title"];
    this._originHref = obj["originHref"];
    this._content = obj["content"];
    this._originCreatedAt = obj["createdAt"];

    var createdAt = DateTime.parse(obj["createdAt"]);
    // var formatter = new DateFormat('yyyy-MM-dd  HH:mm:ss');
    // String formattedCreatedAt = formatter.format(createdAt);
    this._createdAt = createdAt;
    print(obj["marks"]);
    this._isFavorite = obj["marks"] != null;
    this._source = FeedSource.map({"id": obj["source"], "name": "mock"});
  }

  set id(id) => _id = id;
  int get id => _id;
  String get title => _title;
  String get content => _content;
  DateTime get createdAt => _createdAt;
  String get originHref => _originHref;
  bool get isFavorite => _isFavorite;
  FeedSource get source => _source;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["title"] = _title;
    map["originHref"] = _originHref;
    map["content"] = _content;
    map["createdAt"] = _originCreatedAt;
    map["source"] = _source.id;
    map["isFavorite"] = _isFavorite;
    return map;
  }

  Future<Feed> markFeedFavorite() async {
    final FeedMark mark = await api.markFeedFavorite(_id);
    _isFavorite = true;
  }

  Future<void> removeFeedFavoriteMark() async {
    await api.removeFeedFavoriteMark(_id);
    _isFavorite = false;
  }
}
