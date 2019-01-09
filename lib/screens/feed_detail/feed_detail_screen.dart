import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:osyter_app/model/Feed.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedDetailPage extends StatefulWidget {
  Feed feed;
  static String tag = 'feed-detail';

  FeedDetailPage({Key key, @required this.feed}) : super(key: key);

  @override
  FeedDetailPageState createState() => new FeedDetailPageState();
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Car', icon: Icons.directions_car),
  const Choice(title: 'Bicycle', icon: Icons.directions_bike),
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];

class FeedDetailPageState extends State<FeedDetailPage> {
  bool isFavorite;

  Choice _selectedChoice = choices[0]; // The app's "state".

  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
    });
  }

  FeedDetailPageState() {}

  @override
  void initState() {
    super.initState();
    setState(() {
      isFavorite = widget.feed.marks.length > 0;
    });
  }

  _handleIconTap() async {
    if (!isFavorite) {
      await widget.feed.markFeedFavorite();
    }
    setState(() {
      isFavorite = widget.feed.marks.length > 0;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(elevation: 2, actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(Icons.open_in_new, color: Colors.indigo),
            onPressed: () async {
              await launch(widget.feed.originHref);
            },
          ),
          // action button
          IconButton(
            icon: new Icon(isFavorite ? Icons.star : Icons.star_border,
                size: 29, color: Colors.amber),
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
              new Html(data: widget.feed.content),
            ],
          ),
        ));
  }
}
