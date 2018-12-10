class User {
  String _username;
  User(this._username);

  User.map(dynamic obj) {
    this._username = obj["username"];
  }

  String get username => _username;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    return map;
  }
}