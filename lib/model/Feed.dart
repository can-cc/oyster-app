import 'package:osyter_app/model/FeedMark.dart';

class Feed {
  String _id;
  String _title;
  String _originHref;
  String _content;
  String _createdAt;
  List<FeedMark> _marks;

  Feed.map(dynamic obj) {
    this._id = obj["id"].toString();
    this._title = obj["title"];
    this._originHref = obj["originHref"];
    this._content = obj["content"];
    this._createdAt = obj["createdAt"];
    this._marks =
        obj["marks"].map<FeedMark>((mark) => FeedMark.map(mark)).toList();
  }

  String get title => _title;
  String get content => _content;
  List<FeedMark> get marks => _marks;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["title"] = _title;
    map["originHref"] = _originHref;
    map["content"] = _content;
    map["createdAt"] = _createdAt;
    return map;
  }
}
