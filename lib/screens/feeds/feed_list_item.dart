import 'package:flutter/material.dart';
import 'package:osyter_app/model/Feed.dart';

class FeedListItem extends StatelessWidget {
  FeedListItem({Feed feed})
      : feed = feed,
        super(key: ObjectKey(feed));

  final Feed feed;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(feed.title));
  }
}
