import 'package:flutter/material.dart';
import 'package:osyter_app/model/Feed.dart';
import 'package:osyter_app/model/Feeds.dart';
import 'package:osyter_app/screens/feeds/feed_list_item.dart';
import 'package:osyter_app/screens/feeds/feeds_screen_presenter.dart';

class FeedsPage extends StatefulWidget {
  static String tag = 'feeds-page';
  FeedsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  FeedsPageState createState() => new FeedsPageState();
}

class FeedsPageState extends State<FeedsPage> implements FeedsScreenContract {
  List<Feed> items = List();
  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;
  FeedsScreenPresenter _presenter;
  int offset = 0;

  FeedsPageState() {
    _presenter = new FeedsScreenPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _getMoreData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void onFeedReceived(Feeds newFeeds) {
    if (newFeeds.items.isEmpty) {
      double edge = 50.0;
      double offsetFromBottom = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      if (offsetFromBottom < edge) {
        _scrollController.animateTo(
            _scrollController.offset - (edge - offsetFromBottom),
            duration: new Duration(milliseconds: 500),
            curve: Curves.easeOut);
      }
    }
    offset += 30;
    setState(() {
      items.addAll(newFeeds.items);
      isPerformingRequest = false;
    });
  }

  @override
  void onQueryFeedError(String errorText) {
    setState(() {
      isPerformingRequest = false;
    });
  }

  _getMoreData() {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      _presenter.queryFeeds(30, offset);
      // List<Atom> newEntries = (await fetchAtoms()).items; //returns empty list
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Feeds"),
      ),
      body: ListView.builder(
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == items.length) {
            return _buildProgressIndicator();
          } else {
            return FeedListItem(feed: items[index]);
          }
        },
        controller: _scrollController,
      ),
    );
  }
}
