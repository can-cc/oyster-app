import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:osyter_app/model/Feed.dart';

class FeedDetailPage extends StatefulWidget {
  final Feed feed;
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
  Feed feed;

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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(actions: <Widget>[
          // action button
          IconButton(
            icon: Icon(choices[0].icon),
            onPressed: () {
              _select(choices[0]);
            },
          ),
          // action button
          IconButton(
            icon: Icon(choices[1].icon),
            onPressed: () {
              _select(choices[1]);
            },
          ),
          // overflow menu
          PopupMenuButton<Choice>(
            onSelected: _select,
            offset: Offset(0, 50),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: choices[0],
                  child: Text("Option"),
                )
              ];
            },
          ),
        ]),
        body: Center(
          child: ListView(
            padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 12),
            children: <Widget>[
              Text(widget.feed.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Text(widget.feed.createdAt,
                  style:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 12)),
              new Html(data: widget.feed.content),
            ],
          ),
        ));
  }
}
