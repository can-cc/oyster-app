import 'package:intl/intl.dart';
import 'package:osyter_app/data/rest_ds.dart';
import 'package:osyter_app/model/FeedMark.dart';
import 'package:osyter_app/model/FeedSource.dart';

class Feed {
  String _id;
  String _title;
  String _originHref;
  String _content;
  String _createdAt;
  FeedSource _source;
  List<FeedMark> _marks;

  RestDataSource api = new RestDataSource();

  Feed.map(dynamic obj) {
    this._id = obj["id"].toString();
    this._title = obj["title"];
    this._originHref = obj["originHref"];
    this._content = obj["content"];

    var createdAt = DateTime.parse(obj["createdAt"]);
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedCreatedAt = formatter.format(createdAt);
    this._createdAt = formattedCreatedAt;

    this._marks =
        obj["marks"].map<FeedMark>((mark) => FeedMark.map(mark)).toList();
    this._source = FeedSource.map(obj["source"]);
  }

  String get title => _title;
  String get content => _content;
  String get createdAt => _createdAt;
  String get originHref => _originHref;
  List<FeedMark> get marks => _marks;
  FeedSource get source => _source;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["title"] = _title;
    map["originHref"] = _originHref;
    map["content"] = _content;
    map["createdAt"] = _createdAt;
    return map;
  }

  Future<Feed> markFeedFavorite() async {
    final FeedMark mark = await api.markFeedFavorite(_id);
    _marks.add(mark);
  }
}
