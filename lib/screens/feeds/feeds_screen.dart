import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oyster/data/repository.dart';
import 'package:oyster/model/Feed.dart';
import 'package:oyster/model/FeedSource.dart';
import 'package:oyster/model/Feeds.dart';
import 'package:oyster/screens/feeds/feed_list_item.dart';
import 'package:oyster/screens/feeds/feeds_screen_presenter.dart';
import 'package:oyster/screens/setting/setting_screen.dart';

class SelectedCategory {
  final String value;
  final String viewValue;

  const SelectedCategory({
    this.value,
    this.viewValue
  });
}

class FeedsPage extends StatefulWidget {
  static String tag = 'feeds-page';
  FeedsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  FeedsPageState createState() => new FeedsPageState();
}

class FeedsPageState extends State<FeedsPage> implements FeedsScreenContract {
  FeedsScreenPresenter _presenter;

  List<Feed> items = List();
  List<FeedSource> _sources = List();

  ScrollController _scrollController = new ScrollController();
  bool isPerformingRequest = false;

  Repository repository = Repository.get();

  var sourceListener;
  SelectedCategory _selectedCategory = SelectedCategory(
    value: 'all',
    viewValue: 'All'
  );

  int offset = 0;
  final queryCount = 30;

  FeedsPageState() {
    _presenter = new FeedsScreenPresenter(this);
  }

  @override
  void initState() {
    super.initState();

    repository.refreshFeedSource();

    sourceListener =
        repository.getFeedSource$().listen((List<FeedSource> sources) {
      setState(() {
        _sources = sources;
      });
    });

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
    sourceListener.cancel();
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
    offset += queryCount;
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
      _presenter.queryMoreFeeds(queryCount, offset, _selectedCategory.value);
    }
  }

  void _handleBack(Feed feed) {}

  Future<Null> _handleRefresh() async {
    setState(() {
      items.clear();
    });
    final Feeds feeds =
        await _presenter.getHeadFeeds(queryCount, _selectedCategory.value);
    setState(() {
      items.addAll(feeds.items);
      offset = queryCount;
    });
  }

  Future<Null> _handlePressSetting() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingScreen(),
      ),
    );
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
    final drawerSourcesList = _sources.map((FeedSource feedSource) {
      return ListTile(
          title: Text(feedSource.name),
          selected: _selectedCategory.value == feedSource.id,
          onTap: () {
            _selectedCategory = SelectedCategory(
              value: feedSource.id,
              viewValue: feedSource.name
            );
            _handleRefresh();
            Navigator.of(context).pop();
          });
    }).toList();

    final drawerChilren = [
          ListTile(
              leading: Icon(Icons.grain),
              title: Text('All'),
              selected: _selectedCategory.value == "all",
              onTap: () {
                _selectedCategory = SelectedCategory(
                  value: 'all',
                  viewValue: 'All'
                );
                _handleRefresh();
                Navigator.of(context).pop();
              }),
          ListTile(
              leading: Icon(Icons.star, color: Colors.amber),
              title: Text('Star'),
              selected: _selectedCategory.value == 'favorite',
              onTap: () {
                _selectedCategory = SelectedCategory(
                  value: 'favorite',
                  viewValue: 'Star'
                );
                _handleRefresh();
                Navigator.of(context).pop();
              })
        ].toList() +
        drawerSourcesList;

    return new Scaffold(
        drawer: Drawer(
            child: new Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: new CircleAvatar(
                backgroundImage: new AssetImage("assets/logo.png"),
              ),
              accountName: Text("Oyster"),
              accountEmail: Text(""),
              margin: EdgeInsets.only(bottom: 0.0)
            ),
            new Expanded(
              flex: 10,
              child: new Align(
                alignment: FractionalOffset.center,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: drawerChilren,
                ),
              ),
            ),
            new Expanded(
              child: ListTile(
                  leading: Icon(Icons.settings, color: Colors.grey),
                  title: Text('Setting'),
                  onTap: this._handlePressSetting),
            )
          ],
        )),
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: Text("${_selectedCategory.viewValue} feeds", style: TextStyle(color: Colors.white))),
        body: new RefreshIndicator(
            child: ListView.builder(
              itemCount: items.length + 1,
              itemBuilder: (context, index) {
                if (index.isOdd) {
                  return Divider(
                    height: 8,
                  );
                }
                if (index == items.length) {
                  return _buildProgressIndicator();
                } else {
                  return FeedListItem(feed: items[index], onBack: _handleBack);
                }
              },
              controller: _scrollController,
            ),
            onRefresh: _handleRefresh));
  }
}
