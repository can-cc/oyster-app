import 'package:osyter_app/model/Feed.dart';

class Feeds {
  final List<Feed> items;

  Feeds(this.items);

  factory Feeds.fromJson(List<dynamic> feeds) {
    return Feeds(feeds.map((feed) => Feed.map(feed)).toList());
  }
}
