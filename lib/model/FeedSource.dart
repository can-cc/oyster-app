class FeedSource {
  String _id;
  String _name;

  FeedSource.map(dynamic obj) {
    this._id = obj["id"].toString();
    this._name = obj["name"].toString();
  }

  String get id => _id;
  String get name => _name;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["name"] = _name;
    return map;
  }
}
