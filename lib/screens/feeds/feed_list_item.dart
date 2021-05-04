import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oyster/model/Feed.dart';
import 'package:oyster/screens/feed_detail/feed_detail_screen.dart';

typedef OnBack = void Function(Feed feed);

class FeedListItem extends StatefulWidget {
  FeedListItem({Feed feed, this.onBack})
      : feed = feed,
        super();

  Feed feed;
  OnBack onBack;

  @override
  createState() => new FeedListItemState();
}

class FeedListItemState extends State<FeedListItem> {
  bool isFavorite;
  DateFormat _dateFormat = new DateFormat('yyyy-MM-dd  HH:mm:ss');


  @override
  void initState() {
    super.initState();
    setState(() {
      isFavorite = widget.feed.isFavorite;
    });
  }

  _handleIconTap() async {
    if (!isFavorite) {
      await widget.feed.markFeedFavorite();
    } else {
      await widget.feed.removeFeedFavoriteMark();
    }
    setState(() {
      isFavorite = widget.feed.isFavorite;
    });
  }

  _handleTap(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeedDetailPage(feed: widget.feed),
      ),
    );

    setState(() {
      isFavorite = widget.feed.isFavorite;
    });
    widget.onBack(widget.feed);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.feed.title),
            Padding(
              padding: EdgeInsets.only(top: 6.0),
              child: Text(_dateFormat.format(widget.feed.createdAt),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                      color: Colors.grey)),
            ),
          ],
        ),
        trailing: IconButton(
            icon: new Icon(isFavorite ? Icons.star : Icons.star_border,
                size: 30, color: Colors.amber),
            onPressed: _handleIconTap),
        onTap: () {
          _handleTap(context);
        });
  }
}
