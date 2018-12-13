class User {
  String _id;
  String _username;
  User(this._username);

  User.map(dynamic obj) {
    this._id = obj["id"];
    this._username = obj["username"];
  }

  String get username => _username;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = _id;
    map["username"] = _username;
    return map;
  }
}