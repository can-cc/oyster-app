import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:oyster/common/constant.dart';
import 'package:oyster/model/Feed.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedDetailPage extends StatefulWidget {
  Feed feed;
  static String tag = 'feed-detail';

  FeedDetailPage({Key key, @required this.feed}) : super(key: key);

  @override
  FeedDetailPageState createState() => new FeedDetailPageState();
}

class FeedDetailPageState extends State<FeedDetailPage> {
  bool isFavorite;

  FeedDetailPageState() {}

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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(elevation: 2, backgroundColor: PrimaryColor, actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.explore, color: Colors.white, size: 27),
            onPressed: () async {
              await launch(widget.feed.originHref);
            },
          ),
          // action button
          IconButton(
            icon: new Icon(isFavorite ? Icons.star : Icons.star_border,
                size: 29, color: Colors.white),
            onPressed: () {
              _handleIconTap();
            },
          ),
          // overflow menu
        ]),
        body: Center(
          child: ListView(
            padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 12),
            children: <Widget>[
              Text(widget.feed.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(
                height: 10,
              ),
              Text(widget.feed.createdAt,
                  style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 12)),
              SizedBox(
                height: 10,
              ),
              new Divider(),
              SizedBox(
                height: 10,
              ),
              new Html(data: widget.feed.content),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ));
  }
}
