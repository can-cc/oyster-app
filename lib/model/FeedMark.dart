class FeedMark {
  String _id;
  String _type;

  FeedMark.map(dynamic obj) {
    this._id = obj["id"].toString();
    this._type = obj["type"].toString();
  }

  String get id => _id;
  String get type => _type;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["type"] = _type;
    return map;
  }
}
