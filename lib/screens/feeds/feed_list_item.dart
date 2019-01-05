import 'package:flutter/material.dart';
import 'package:osyter_app/model/Feed.dart';

class FeedListItem extends StatefulWidget {
  FeedListItem({Feed feed})
      : feed = feed,
        super();

  final Feed feed;

  @override
  createState() => new FeedListItemState();
}

class FeedListItemState extends State<FeedListItem> {
  bool isFavorite;

  @override
  void initState() {
    super.initState();
    setState(() {
      isFavorite = widget.feed.marks.length > 0;
    });
  }

  _handleTap() async {
    if (!isFavorite) {
      await widget.feed.markFeedFavorite();
    }
    setState(() {
      isFavorite = widget.feed.marks.length > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(widget.feed.title),
        trailing: new Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.red),
        onTap: _handleTap);
  }
}
