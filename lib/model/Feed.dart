class Feed {
  String _id;
  String _title;
  String _originHref;
  String _content;
  String _createdAt;

  Feed.map(dynamic obj) {
    this._id = obj["id"].toString();
    this._title = obj["title"];
    this._originHref = obj["originHref"];
    this._content = obj["content"];
    this._createdAt = obj["createdAt"];
  }

  String get title => _title;

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
